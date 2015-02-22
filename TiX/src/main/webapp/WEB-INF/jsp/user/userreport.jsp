<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@
taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<%@ include file="/WEB-INF/jsp/head.jsp"%>
<body>
	<%@ include file="/WEB-INF/jsp/header.jsp"%>
	<div class="container-fluid">
		<div class="row-fluid">
			<h3>
				Tabla de medianas mensuales
				</h2>
				<div id="meantable">
					<table class="table table-striped" width="647">
						<thead>
							<tr>
								<th>ISP</th>
								<th>Calidad Subida</th>
								<th>Calidad Bajada</th>
								<th>Utilizacion Subida</th>
								<th>Utilizacion Bajada</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${ispNames}"  var="entry " varStatus="status">
								<tr>
										<td>${ispNames[status.index]}</td>
										<td><c:if test="${empty medianList[status.index][0]}">0</c:if><fmt:formatNumber value="${medianList[status.index][0]}" pattern="0.00"/></td>
										<td><c:if test="${empty medianList[status.index][1]}">0</c:if><fmt:formatNumber value="${medianList[status.index][1]}" pattern="0.00"/></td>
										<td><c:if test="${empty medianList[status.index][2]}">0</c:if><fmt:formatNumber value="${medianList[status.index][2]}" pattern="0.00"/>%</td>
										<td><c:if test="${empty medianList[status.index][3]}">0</c:if><fmt:formatNumber value="${medianList[status.index][3]}" pattern="0.00"/>%</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<div id="meantabledescription">
					Esta tabla muestra las medianas mensuales de cada uno de los parámetros estudiados para cada uno de los proveedores de internet que utilizó el usuario.
				</div>
				</br></br>
		</div>
	</div>
	<div class="container-fluid">
	 <!-- para cada una de las instalaciones tengo que mostrar el grÃ¡fico del usuario -->

	 <c:forEach items="${javaChart_list}" var="entry" varStatus="status">
			<div id="graphcontainer${status.index}"></div>
			<div id="chartdescription">
					Este gráfico muestra la evolución de los cuatro parámetros estudiados con información para los datos obtenidos para la instalación ${userInstallations[status.index]}
			</div>
			</br></br>
	 </c:forEach>

	</div>

</body>

<c:forEach items="${javaChart_list}" var="entry" varStatus="status">
	<script type="text/javascript">
	            $(function () {
	            	 var datos =  ${entry.JSONString};
	            	 for (var i=0;i<datos.length;i++){
	            	  	for (var j=0;j<datos[i].data.length;j++){
	            	  		if(datos[i].data[j] == -1){
	            	  			datos[i].data[j] = null;// = null;
	            	  		}else if (datos[i].data[j].y == -1){
	            			 	datos[i].data[j].y = null;
	            			}
	            		}
	            	 }


	                 var fechas = ${entry.timestamps};
	                 var title = "${entry.title}";
	                 //var redmarker = ${javaChart.redmarker};
	                 var subtitle = "${entry.subtitle}";
	                for (var i=0;i<fechas.length;i++){
	                	fechas[i] = new Date(fechas[i]);
	                }
	                var chart;
	                $(document).ready(function() {
	                    chart = new Highcharts.Chart({

	                        chart: {
	                        		// type: 'columnrange'
	                            renderTo: 'graphcontainer${status.index}',
	                          	marginRight: 130,
	                           	marginBottom: 40
	                        },

	                        title: {
	                            text: title,
	                            x: -20 //center
	                        },

	                        subtitle: {
	                            text: subtitle,
	                            x: -20
	                        },

	                        xAxis: {
	                        	type: 'datetime',
	                            //plotBands: redmarker,
	                            categories: fechas,
	                            tickInterval: 6,
	                            labels: {
	                            	enabled: true,
	                                formatter: function() {
	                                    // return Highcharts.dateFormat('%d/%m <br/>(%H:%Mhs)', this.value);
	                                    return Highcharts.dateFormat('%d/%m', this.value);
	                                },
	                            },
	                        },

	                        yAxis: {
	                            title: {
	                                text: '% de utilizacion'
	                            },
	                            plotLines: [{
	                                    value: 0,
	                                    width: 1,
	                                    color: '#808080'
	                                }],
	                           	min: 0, max: 100
	                        },

	                         plotOptions: {
							                series: {
							                    cursor: 'pointer',
							                    turboThreshold: 2000,
							                    enableMouseTracking: false,
							                    shadow: false,
							                    animation: false,
							                    point: {
							                        events: {
							                            click: function() {
							                                $.holdReady(true);
							                                $.get("./changeCongestionStatus?id=" + this.id + "&type=" + this.type, function() {
															  $.holdReady(false);
															});
															var delay = 500; //Your delay in milliseconds
															setTimeout(function(){ window.location = $(location).attr('href'); }, delay);
							                            }
							                        }
							                    },
							                    marker: {
							                        lineWidth: 1
							                    }
							                }
	            						},

	                        tooltip: {
	                            shared: true,
	                            crosshairs: true
	                        },

	                        legend: {
	                            layout: 'vertical',
	                            align: 'right',
	                            verticalAlign: 'top',
	                            x: -10,
	                            y: 100,
	                            borderWidth: 0
	                        },

	                        scrollbar: {
	                            enabled: false
	                        },

	                        series: datos
	                    });
	                });
	            });

	        </script>
</c:forEach>

</html>

