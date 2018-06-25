import groovy.sql.Sql


class ModuleAction extends ActionSupport {

   def String execute(){
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
       def projects_count = connection.firstRow("select count(*) AS num from projects where status = 'in progress'").num
       def tickets_unsolved = connection.firstRow("select count(*) AS num from tickets where status != 'finished'").num
       def bills_count = connection.firstRow("select count(*) AS num from bills b, projects p where b.product_id = p.id and b.status = 'stand by'").num
       connection.close() 
       request.setAttribute("projects",projects)  
       request.setAttribute("projects_count",projects_count)
       request.setAttribute("tickets_unsolved",tickets_unsolved)
       request.setAttribute("bills_count",bills_count)
   	   SUCCESS
   }
     	
	def getConnection() {
		new Sql(dataSource)
	}
	
}