<html>
<%@ include file="/WEB-INF/jsp/head.jsp"%>
<body>

	<%@ include file="/WEB-INF/jsp/header.jsp"%>
	<div class="container">
		<section id="typography">
			<div class="page-header">
				<h1>Bienvenido al Proyecto TiX_</h1>
			</div>

			<!-- Headings & Paragraph Copy -->
			<div class="row">
				<div class="span12">
					<h3>Sobre el Proyecto TiX</h3>
					<p>El proyecto TiX nace de un subsidio de LACNIC con el fin de diponer de
						una herramienta para medir la calidad de los accesos a Internet.</p>
					<p>Del mismo participan las siguintes instituciones:</p>
				</div>
				<div class="span12">
					<div class="row-fluid">
						<ul class="thumbnails">
							<li class="span4" style="text-align: center;"><a href="http://lacnic.net/" target="_blank"> <img
									alt="LacNIC"
									class="img-polaroid"
									style=""
									src="<c:url value='/img/lacnic.jpg'/>">
							</a></li>
							<li class="span4" style="text-align: center;"><a href="http://www.itba.edu.ar/" target="_blank"> <img
									alt="ITBA"
									class="img-polaroid"
									style=""
									src="<c:url value='/img/itba.jpg'/>">
							</a></li>
							<li class="span4" style="text-align: center;"><a href="http://www.udesa.edu.ar/" target="_blank"> <img
										alt="udesa"
										class="img-polaroid"
										style=""
										src="<c:url value='/img/UdeSA.jpg'/>">
								</a></li>

							</ul>
						</div>
					</div>

					<div class="span12 offset2">
						<div class="row-fluid">
							<ul class="thumbnails">

								<li class="span4" style="text-align: center;"><a href="http://www.innova-red.net/" target="_blank"> <img
											alt="InnovaRED"
											class="img-polaroid"
											style=""
											src="<c:url value='/img/innovared.jpg'/>">
								</a></li>

								<li class="span4" style="text-align: center;"><a href="http://www.uba.ar/" target="_blank"> <img
										alt="UBA"
										class="img-polaroid"
										style="width: 150px; height: 150px;"
										src="<c:url value='/img/uba2.jpg'/>">
								</a></li>

							</ul>
				</div>
			</div>

			</div>
			<hr/>
			<div class="row">
				<div class="span12">
					<h3>Investigadores responsables</h3>
					<p>Dr. Hern&aacute;n Galperin (<a href="http://www.conicet.gov.ar/new_scp/detalle.php?id=38012&datos_academicos=yes" target="_blank">CONICET</a> y <a href="http://www.unsa.edu.ar/" target="_blank">UnSA</a>)</p>
					<p>Dr. Ing. Jos&eacute; Ignacio Alvarez-Hamelin (<a href="http://www.conicet.gov.ar/new_scp/detalle.php?id=24474&datos_academicos=yes" target="_blank">CONICET</a>, <a href="http://www.uba.ar/" target="_blank">UBA</a> e <a href="http://www.itba.edu.ar/" target="_blank">ITBA</a>)</p>
				</div>
			</div>
			<hr/>
			<div class="row">
				<div class="span12">
					<h3>Colaboradores</h3>
					<p>Federicio Ezequiel García (<a href="http://www.uba.ar/" target="_blank">UBA</a>)</p>
					<p>Cristian Pereyra (<a href="http://www.itba.edu.ar/" target="_blank">ITBA</a>)</p>
					<p>Jos&eacute; Ignacio Galindo (<a href="http://www.itba.edu.ar/" target="_blank">ITBA</a>)</p>
					<p>Alan Karpovsky (<a href="http://www.itba.edu.ar/" target="_blank">ITBA</a>)</p>
					<p>Nicolas Loreti (<a href="http://www.itba.edu.ar/" target="_blank">ITBA</a>)</p>
					<p>Paula Verghelet (<a href="http://www.uba.ar/" target="_blank">UBA</a>)</p>
					<p>Ing. Esteban Poggio (<a href="http://www.uba.ar/" target="_blank">UBA</a>)</p>
					<p>Estudiantes de Introducci&oacute;n a los sistemas distribuidos, 2do cuatrimestre 2012.</p>
				</div>
			</div>
		</section>
	</div>
	<%@ include file="/WEB-INF/jsp/footer.jsp"%>
</body>
</html>
