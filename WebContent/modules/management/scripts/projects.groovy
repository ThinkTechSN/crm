import app.FileManager
import groovy.sql.Sql
import static org.apache.commons.io.FileUtils.byteCountToDisplaySize as byteCount

class ModuleAction extends ActionSupport {

   def showProjects(){
       def connection = getConnection()
       def projects = []
       connection.eachRow("select p.id,p.subject,p.date,p.status,p.progression, u.name as author, s.name as structure from projects p, users u, structures s where p.user_id = u.id and u.structure_id = s.id order by p.date DESC", [], { row -> 
          def project = new Expando()
          project.id = row.id
          project.subject = row.subject
          project.date = row.date
          project.status = row.status
          project.progression = row.progression
          project.author =  row.author
          project.structure = row.structure
          projects << project
       })
       def active = connection.firstRow("select count(*) AS num from projects where status = 'in progress'").num
       def unactive = connection.firstRow("select count(*) AS num from projects where status = 'stand by'").num
       connection.close() 
       request.setAttribute("projects",projects)  
       request.setAttribute("total",projects.size())
       request.setAttribute("active",active)
       request.setAttribute("unactive",unactive)
       SUCCESS
    }
    
    def openProject(){
       def project = parse(request)
       Thread.start {
	   	  def connection = getConnection()
	      connection.executeUpdate "update projects set status = 'in progress' where id = ?", [project.id] 
	      connection.close()
	   }
       json([status: 1])
    }
	
	def getProjectInfo() {
	   def id = getParameter("id")
	   def connection = getConnection()
	   def project = connection.firstRow("select p.*,u.name,d.name as domain from projects p,users u, domains d where p.id = ? and p.user_id = u.id and p.domain_id = d.id", [id])
	   if(project.status == 'finished'){
	      project.end = project.closedOn
	      project.duration = connection.firstRow("select TIMESTAMPDIFF(MONTH,startedOn,closedOn) as duration from projects where id = ?", [project.id]).duration
	   }
	   else if(project.status == 'in progress'){ 
	   	project.end = connection.firstRow("select date_add(startedOn,interval duration month) as end from projects where id = ?", [project.id]).end
	   }
	   else{ 
	   	project.end = connection.firstRow("select date_add(date,interval duration month) as end from projects where id = ?", [project.id]).end
	   }
	   project.date = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss").format(project.date)
	   project.end = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss").format(project.end)
	   project.comments = []
	   connection.eachRow("select c.id, c.message, c.date, u.name from projects_comments c, users u where c.createdBy = u.id and c.project_id = ?", [project.id],{ row -> 
          def comment = new Expando()
          comment.with{
           id = row.id
           author = row.name
           date = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss").format(row.date)
           message = row.message  
          }
          project.comments << comment
       })
       project.documents = []
	   connection.eachRow("select d.project_id, d.name, d.size, d.date, u.name as author from documents d, users u where d.createdBy = u.id and d.project_id = ?", [project.id],{ row -> 
          def document = new Expando()
          document.with{
          	project_id = row.project_id
            author = row.author
            date = new SimpleDateFormat("dd/MM/yyyy - HH:mm:ss").format(row.date)
            name = row.name
            size = byteCount(row.size as long) 
          }
          project.documents << document
       })
       project.tasks = []
	   connection.eachRow("select name,description,info,status,progression from projects_tasks where project_id = ?", [project.id],{ row -> 
          def task = new Expando()
          task.with{
            name = row.name
            description = row.description
            status = row.status
            progression = row.progression
            info = row.info ? row.info : "aucune information" 
          }
          project.tasks << task
       })
	   connection.close() 
	   json([entity : project])
	}
	
    def updateTask(){
       def task = parse(request)
       Thread.start {
	   	  def connection = getConnection()
	      connection.executeUpdate "update projects_tasks set status = ?, progression = ?, info = ?, closedOn = if(? = 100,NOW(),null) where id = ?", [task.status,task.progression,task.info,task.progression,task.id] 
	      if(task.status == 'finished') {
	        connection.executeUpdate "update projects set progression = (select (count(*) * 10) from projects_tasks p where p.status = 'finished' and p.project_id = ?) where id = ?", [task.project_id,task.project_id]
	        connection.executeUpdate "update projects set status = if((select count(*) * 10 from projects_tasks p where p.status = 'finished' and p.project_id = ?) = 100, 'finished', status) where id = ?", [task.project_id,task.project_id]
	        connection.executeUpdate "update projects set closedOn = if((select count(*) * 10 from projects_tasks p where p.status = 'finished' and p.project_id = ?) = 100, NOW(), null) where id = ?", [task.project_id,task.project_id]
	       }else{
	         connection.executeUpdate "update projects set progression = (select (count(*) * 10) from projects_tasks p where p.status = 'finished' and p.project_id = ?) where id = ?", [task.project_id,task.project_id]
	         connection.executeUpdate "update projects set closedOn = null,status = 'in progress' where id = ?", [task.project_id]
	       }
	      connection.close()
	   }
       json([status: 1])
    }
    
     def openTask(){
       def task = parse(request)
       Thread.start {
	   	  def connection = getConnection()
	      connection.executeUpdate "update projects_tasks set status = 'in progress', startedOn = NOW() where id = ?", [task.id] 
	      connection.close()
	   }
       json([status: 1])
    }
    	
	def updateProjectPriority(){
	    def project = parse(request) 
	    Thread.start {
	   	   def connection = getConnection()
	       connection.executeUpdate "update projects set priority = ? where id = ?", [project.priority,project.id] 
	       connection.close()
	    }
		json([status: 1])
	}
	
	def addComment() {
	   def comment = parse(request) 
	   def user_id = user.id
	   Thread.start { 
	   	 def connection = getConnection()
	     def params = [comment.message,comment.project,user_id]
         connection.executeInsert 'insert into projects_comments(message,project_id,createdBy) values (?,?,?)', params
	     connection.close()
	   }
	   json([status: 1])
	}
	
	def saveDocuments() {
	   def upload = parse(request) 
	   def id = upload.id
	   def user_id = user.id
	   Thread.start {
	     def connection = getConnection()
	     def query = 'insert into documents(name,size,project_id,createdBy) values (?,?,?,?)'
         connection.withBatch(query){ ps ->
           for(def document : upload.documents) ps.addBatch(document.name,document.size,id,user_id)
         }
	     connection.close()
	   }
	   json([status: 1])
	}
	
	def downloadDocument(){
	   def project_id = getParameter("project_id")
	   def connection = getConnection()
	   def structure_id = connection.firstRow("select structure_id from projects where id = "+project_id).structure_id
       connection.close()
	   def dir = "structure_"+structure_id+"/"+"project_"+project_id
	   def name = getParameter("name")
	   response.contentType = context.getMimeType(name)
	   response.setHeader("Content-disposition","attachment; filename=$name")
	   def fileManager = new FileManager()
	   fileManager.download(dir+"/"+name,response.outputStream)
	}
	
	def updateProjectDescription() {
	   def project = parse(request)
	   Thread.start {
	   	 def connection = getConnection()
	     connection.executeUpdate "update projects set description = ? where id = ?", [project.description,project.id] 
	     connection.close()
	   }
	   json([status: 1])
	}
	
	def getConnection() {
		new Sql(dataSource)
	}
	
}