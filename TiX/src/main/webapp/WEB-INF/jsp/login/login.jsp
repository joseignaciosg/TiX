<html>
<%@ include file="/WEB-INF/jsp/head.jsp"%>
<style>
.caption {
	float: left;
	width: 270px;
}

.span8 {
	width: 350px;
}

.thumb_image {
	width: 187x;
	height: 187px;
	float: left;
}

.clear {
	clear: both;
}
</style>
<body>

	<%@ include file="/WEB-INF/jsp/header.jsp"%>
	<div class="container">

		<div class="row-fluid">
			<div class="span6">
				<h3>Proyecto TiX</h3>
				<div class="thumb_image">
					<img alt="Logo Tix" src="<c:url value='/img/logo_TiX.png'/>">
				</div>
				<div class="row caption pull-left" style="margin-left: 20px;width: 245px;">
					<div class="span12">
						<h4>&iquest;Qu&eacute; es el Proyecto Tix?</h4>
						<p>TiX (Traffic information eXchange) es una herramienta que
							permite efectuar una medici&oacute;n de la calidad de su acceso a
							Internet.</p>
						<a class="btn btn-info btn-large" href="../account/register">Instalar TiX</a>

					</div>
				</div>
				<div class="clear"></div>


			</div>
			<div class="span6">
				<h3>Iniciar sesi&oacute;n</h3>
				<div class="form-horizontal well">
					<form:form action="../login/login" method="POST"
						commandName="userLoginForm">
						<fieldset>
							<div class="control-group">
								<div class="controls">
									<form:errors path="*" cssClass="label label-important" />
								</div>
							</div>

							<div class="control-group">
								<label class="control-label" for="nickname">Email</label>
								<div class="controls">
									<form:input type="text" id="nickname" class="" path="nickname" />
								</div>
							</div>

							<div class="control-group">
								<label class="control-label" for="password">Contrase&ntilde;a</label>
								<div class="controls">
									<form:input type="password" id="password" class=""
										path="password" />
									<br /> <a href="<c:url value='/bin/account/recover'/>">
										&iquest;Olvid&oacute; su contrase&ntilde;a? </a>
								</div>
							</div>
							<div class="control-group">
								<div class="controls">
									<input class="btn btn-primary btn-large" type="submit"
										value="Enviar" />
								</div>
							</div>
						</fieldset>
					</form:form>
				</div>
			</div>
			<div class="row">
				<div class="span4">
					<h4>
						&iquest;Cu&aacute;l es el objetivo?
					</h4>
					<p>El algoritmo ejecuta la medici&oacute;n enviando un paquete
						de datos por segundo, asegurando un consumo inperceptible de su
						conexi&oacute;n a Internet y permitiendo un monitoreo las 24hs del
						d&iacute;a y los 365 d&iacute;as del a&ntilde;o.</p>
				</div>
				<div class="span4">
					<h4>
						&iquest;Qu&eacute; resultados arroja?
					</h4>
					<p>Las mediciones se realizan todo el tiempo, generando un
						informe, tanto en formato web interactivo como en PDF mensual,
						detallando los momentos en que su proveedor de Internet no puede
						entregarle el tr&aacute;fico m&aacute;ximo contratado.</p>
				</div>
				<div class="span4">
					<h4>
						&iquest;C&oacute;mo puedo usar TiX?
					</h4>
					<p>
						Puede crear su cuenta e instalar el software de medici&oacute;n en
						su PC y/o computadora port&aacute;til aqu&iacute;:  <a
							class="btn btn-info" href="../account/register">Instalar
							TiX</a>

					</p>
				</div>
			</div>
			<hr />
		</div>
	</div>
	<%@ include file="/WEB-INF/jsp/footer.jsp"%>
</body>
</html>
