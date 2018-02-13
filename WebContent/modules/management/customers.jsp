<%@ taglib prefix="s" uri="/struts-tags"%>
<div class="inner-block">
<div class="logo-name">
		<h1><i class="fa fa-${activeItem.icon}" aria-hidden="true"></i>${activeItem.label}</h1> 								
</div>
<!--info updates updates-->
	 <div class="info-updates">
			<div class="col-md-4 info-update-gd">
				<div class="info-update-block clr-block-1">
					<div class="col-md-8 info-update-left">
						<h3 class="active">${total}</h3>
						<h4>clients</h4>
					</div>
					<div class="col-md-4 info-update-right">
						<i class="fa fa-${activeItem.icon}"> </i>
					</div>
				  <div class="clearfix"> </div>
				</div>
			</div>
			<div class="col-md-4 info-update-gd">
				<div class="info-update-block clr-block-1">
					<div class="col-md-8 info-update-left">
						<h3 class="active">${unactive}</h3>
						<h4>nouveaux clients</h4>
					</div>
					<div class="col-md-4 info-update-right">
						<i class="fa fa-${activeItem.icon}"> </i>
					</div>
				  <div class="clearfix"> </div>
				</div>
			</div>
		   <div class="clearfix"> </div>
		</div>
<!--info updates end here-->
<!--mainpage chit-chating-->
<div class="chit-chat-layer1">
	<div class="col-md-12 chit-chat-layer1-left">
               <div class="work-progres">
                    <div class="chit-chat-heading">
                        <h3 class="tlt">${activeItem.label}</h3>
                    </div>
                    <div class="customers table-responsive">
                      <table data-url="${url}/customers/info" class="customers table table-hover">
                                  <thead>
                                    <tr>
                                      <th></th>
                                      <th>Pr�nom et Nom</th>
                                      <th>Structure</th>
                                      <th>Date Cr�ation</th> 
                                      <th>Profession</th>                                                            
                                      <th>Email</th>
                                      <th>T�l�phone</th>
                                  </tr>
                              </thead>
                              <tbody>
                              <s:iterator value="#request.customers" var="customer" status="status">
	                                <tr id="${customer.properties.id}">
	                                  <td><span class="number">${status.index+1}</span></td>
	                                  <td><i class="fa fa-user" aria-hidden="true"></i> ${customer.properties.name}</td>
	                                  <td>${customer.properties.structure}</td>
	                                  <td><s:date name="properties.createdOn" format="dd/MM/yyyy" /></td>                                        
	                                  <td>${customer.properties.profession}</td>
	                                  <td>${customer.properties.email}</td>
	                                  <td>${customer.properties.telephone}</td>
	                              </tr>
	                          </s:iterator>
                          </tbody>
                      </table>
                      <div class="empty"><span>aucun client</span></div>            
                    </div>
             </div>
      </div>
     <div class="clearfix"> </div>
 </div>
 <div class="window details">
	   <div>
		<span title="fermer" class="close">X</span>
		<section>
		 <template>
		 <h1><i class="fa fa-${activeItem.icon}" aria-hidden="true"></i>Client</h1>
		<fieldset>
			<span class="text-right"><i class="fa fa-user" aria-hidden="true"></i> Client </span> <span>{name}</span> 
			<span class="text-right"><i class="fa fa-user" aria-hidden="true"></i> Structure </span> <span>{structure|s}</span>
			<span class="text-right"><i class="fa fa-calendar" aria-hidden="true"></i> Date Cr�ation </span> <span>{createdOn}</span>
			<span class="text-right"><i class="fa fa-calendar" aria-hidden="true"></i> Profession </span> <span>{profession|s}</span>
			<span class="text-right"><i class="fa fa-calendar" aria-hidden="true"></i> Email </span> <span>{email}</span>
			<span class="text-right"><i class="fa fa-calendar" aria-hidden="true"></i> T�l�phone </span> <span>{telephone|s}</span>
		</fieldset>
		</template>
		</section>
		</div>
	</div>
</div>
<script src="${js}/customers.js" defer></script>
<script src="js/tinymce/tinymce.min.js" defer></script> 