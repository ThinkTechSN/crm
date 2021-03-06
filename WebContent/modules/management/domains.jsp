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
						<h3 class="domainCount">${total}</h3>
						<h4>domaines</h4>
					</div>
					<div class="col-md-4 info-update-right">
						<i class="fa fa-${activeItem.icon}"> </i>
					</div>
				  <div class="clearfix"> </div>
				</div>
			</div>
			<div class="col-md-4 info-update-gd">
				<div class="info-update-block clr-block-3">
					<div class="col-md-8 info-update-left">
						<h3 class="domainUnregistered">${unregistered}</h3>
						<h4>domaines non enregistr�s</h4>
					</div>
					<div class="col-md-4 info-update-right">
						<i class="fa fa-${activeItem.icon}"> </i>
					</div>
				  <div class="clearfix"> </div>
				</div>
			</div>
			<div class="col-md-4 info-update-gd">
				<div class="info-update-block clr-block-6">
					<div class="col-md-8 info-update-left">
						<h3 class="domainRegistered">${registered}</h3>
						<h4>domaines enregistr�s</h4>
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
                            <div class="table-responsive">
                                <table data-url="${url}/domains/info" class="domains table table-hover">
                                  <thead>
                                    <tr class="clr-block-6">
                                      <th></th>
                                      <th>Domaine</th>
                                      <th>Auteur</th>
                                      <th>Structure</th>
                                      <th>Date Cr�ation</th>  
                                      <th>Dur�e</th>
                                      <th>Montant</th>                                                          
                                      <th style="width:95px">Enregistrement</th>
                                  </tr>
                              </thead>
                              <tbody>
                               <s:iterator value="#request.domains" var="domain" status="counter">
	                                <tr id="${domain.id}" class="${domain.status=='finished' ? 'paid' : ''}">
	                                  <td><span class="number">${counter.index+1}</span></td>
	                                  <td>${domain.name}  <i class="fa fa-check" aria-hidden="true" style="display : ${domain.verified ? 'inline-block' : 'none' }"></i></td>
	                                  <td>${domain.author}</td>
	                                  <td>${domain.structure}</td>
	                                  <td><s:date name="date" format="dd/MM/yyyy" /></td>
	                                  <td>${domain.year} an</td>
                                  	  <td><span class="digit">${domain.price}</span> CFA</td>                                        
	                                  <td><span class="label ${domain.status=='in progress' ? 'label-danger' : '' } ${domain.status=='finished' ? 'label-success' : '' } ${domain.status=='stand by' ? 'label-info' : '' }">
	                                  ${domain.status=='in progress' ? 'en cours' : '' } ${domain.status=='finished' ? 'termin�' : '' } ${domain.status=='stand by' ? 'en attente' : '' }
	                                  </span> <i class="fa fa-envelope ${domain.emailActivatedOn!=null ? 'success' : 'stand-by' }" aria-hidden="true" style="display : ${domain.emailOn ? 'inline-block' : 'none' }"></i></td>
	                              </tr>
	                          </s:iterator>
	                          <template>
							     {#.}
							      <tr id="{id}">
							            <td><span class="number"></span></td>
							   	        <td>{domain}</td>
							   	        <td>${user.name}</td>
							   	        <td>{date}</td> 
							   	        <td>{year} an</td>
							   	        <td><span class="digit">{price}</span> CFA</td> 
							            <td><span class="label label-info">en attente</span></td>
							   	    </tr>
							     {/.}
							   </template>
                          </tbody>
                      </table>
                      <div class="empty"><span>aucun domaine</span></div>
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
		 <h1><i class="fa fa-${activeItem.icon}" aria-hidden="true"></i>Details Du Domaine</h1>
		<fieldset>
		    <span class="text-right"><i class="fa fa-globe" aria-hidden="true"></i> Nom </span> <span>{name}</span>
		    <span class="text-right"><i class="fa fa-user" aria-hidden="true"></i> Auteur </span> <span>{author}</span>
		    <span class="text-right"><i class="fa fa-envelope" aria-hidden="true"></i> Email </span> <span>{authorEmail}</span>
		    <span class="text-right"><i class="fa fa-building" aria-hidden="true"></i> Structure </span> <span>{structure}</span>
		    <span class="text-right zoid"><i class="fa fa-code" aria-hidden="true"></i> Zoho id </span> <span class="zoid">{zoid}</span>
			<span class="text-right"><i class="fa fa-calendar" aria-hidden="true"></i> Date Cr�ation</span> <span>{date}</span>
			<span class="text-right"><i class="fa fa-calendar" aria-hidden="true"></i> Dur�e </span> <span>{year} an</span>
			<span class="text-right"><i class="fa fa-money" aria-hidden="true"></i> Montant </span> <span><b class="digit">{price}</b> CFA</span>
			<span class="text-right"><i class="fa fa-tasks" aria-hidden="true"></i> Action </span> <span>{action}</span>
			<div class="eppCode">
			 <fieldset>
			  <span class="text-right"><i class="fa fa-code" aria-hidden="true"></i> EPP Code </span> <span>{eppCode|s}</span>
			 </fieldset>
			</div>
			<div class="manage">
			    <fieldset>
			     <span class="text-right"><i class="fa fa-calendar" aria-hidden="true"></i> Enregistr� le  </span> <span>{registeredOn}</span>
			 	 <span class="text-right"><i class="fa fa-building" aria-hidden="true"></i> Registrar </span> <span>{registrar}</span>
			 	 <span class="text-right"><i class="fa fa-cog" aria-hidden="true"></i> Service DNS </span> <span><a href="https://cloudlogin.co" target="_blank" rel="nofollow">[ manage ]</a></span>
			 	</fieldset>
			</div>
			<div class="businessEmail">
			   <h1><i class="fa fa-envelope" aria-hidden="true"></i>Business Email</h1>
			    <fieldset>    
		         <input type="radio" checked="checked" id="free"
			     name="plan" value="free">
			    <label for="free">Plan Free</label>
			    <br>
			    <input type="radio" id="lite"
			     name="plan" value="lite">
			    <label for="lite">Plan Lite</label>
			    <br>
			    <input type="radio" id="standard"
			     name="plan" value="standard">
			    <label for="standard">Plan Standard</label>
			    <br>
			    <input type="radio" id="professional"
			     name="plan" value="professional">
			    <label for="professional">Plan Professional</label>
			    <div>
			     <i class="fa fa-user" aria-hidden="true"></i> <input type="text" placeholder="super administrateur" name="email" maxlength="200"/>
			     <div class="buttons" style="display:inline-block;padding-left:0px;top:0px">
			     <a class="create" href="${url}/domains/createMailAccount">Cr��r Compte</a>
			     <a class="activate" href="${url}/domains/activateMailOffer">Activer</a>
			    </div>
			    <a class="domain-manage" href="https://mailadmin.zoho.com/cpanel/index.do#managecustomers" target="_blank">Manage</a>
			    </div>
			    <div>
			      <span class="info info-payment">la configuration du business email est en attente et le client doit d'abord s'acquiter de toutes ses factures.</span>
			      <span class="info info-success">la configuration du business email de ce client est maintenant termin�e.</span>
			    </div> 
		    </fieldset>
			</div>
		</fieldset>
		<form action="${url}/domains/register">
			<div class="submit">
			   <input type="submit" value="Enregistrer">
			   <input type="button" value="Annuler">
			</div>
		</form>
		</template>
		</section>
	</div>
</div>
</div>
<script>
 <%@include file="/modules/management/js/domains.js"%>
</script>