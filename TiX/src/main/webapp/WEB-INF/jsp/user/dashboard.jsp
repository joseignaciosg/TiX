<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@
taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page contentType="text/html;charset=UTF-8"%>

<html>
<%@ include file="/WEB-INF/jsp/head.jsp"%>

<body>
	<%@ include file="/WEB-INF/jsp/header.jsp"%>
	<div class="container-fluid">
      <div class="row-fluid">
        <div class="span3">
          <div class="well sidebar-nav">
            <ul class="nav nav-list">
              <li class="nav-header">Instalaciones </li>
              	<c:forEach items="${installationISPMap}" var="entry">
            		<li class='<c:if test="${entry.key.id == currentInstallation.id}">active listExpanded</c:if><c:if test="${entry.key.id != currentInstallation.id}">listCollapsed</c:if>'>
<!--             		<li class="listCollapsed"> -->
						<a id="toggler" href="./dashboard?nickname=${user.nickname}&graphtype=${currentGraphType}&ins=${entry.key.id}" data-toggle="collapse" class="toggler active" data-target="#${entry.key.id}_isps">
							<i class="icon-folder-open"></i>
							<i class="icon-folder-close"></i>
							${entry.key.name}
						</a>
					</li>
    				<ul id="${entry.key.id}_isps" class="<c:if test="${entry.key.id != currentInstallation.id}">collapse</c:if>">
    					<li  class='<c:if test="${entry.key.id == currentInstallation.id && requiredISP == null}">activeISP</c:if>'><a  href="./dashboard?nickname=${user.nickname}&graphtype=${currentGraphType}&ins=${entry.key.id}">General</a></li>
	    				<c:forEach var="isp" items="${entry.value}">
		              		<li class='<c:if test="${entry.key.id == currentInstallation.id && isp.id == requiredISP.id}">activeISP</c:if>'><a href="./dashboard?nickname=${user.nickname}&graphtype=${currentGraphType}&ins=${entry.key.id}&isp=${isp.id}">${isp.name}</a></li>
	              		</c:forEach>
	              	</ul>
				</c:forEach>
  	          <li class="divider"></li>
              	<li><a href="../installation/downloadapp"><i class="icon-plus-sign"></i>Nueva instalaci&oacute;n</a></li>
              	<li><a href="../installation/allinstallations"><i class="icon-pencil"></i>Editar instalaci&oacute;nes</a></li>
	          <li class="divider"></li>
	          <li><a href="#">Ayuda</a></li>
            </ul>
          </div><!--/.well -->
        </div><!--/span-->
        <div class="span9">
			<c:choose>
	        	<c:when test="${noRecords}">
	        		<div class="span12">
				        <div class="alert alert-block">
				          <a class="close">×</a>
				          <h4 class="alert-heading">No hay registros</h4>
				          <p>Lo sentimos pero no hemos encontrado registros para la instalaci&oacute;n seleccionada.</p>
				        </div>
				    </div>
	        	</c:when>
	        	<c:otherwise>
					   		<form method="GET"  action="./dashboard" class="form-horizontal offset2" style="padding-left:10px;">
						   		<div class="input-prepend" data-date-format="dd-mm-yyyy">
								  <span class="add-on"><i class="icon-calendar"></i></span>
						   			<input type="text" class="span8" value="${minDate}" name="minDate" id="dpd1" placeholder="Fecha desde"/>
								</div>
								<div class="input-prepend" data-date-format="dd-mm-yyyy">
								  <span class="add-on"><i class="icon-calendar"></i></span>
						   			<input type="text" class="span8" value="${maxDate}" name="maxDate" id="dpd2" placeholder="Fecha hasta"/>
								</div>
								<input type="hidden"  value="${user.nickname}" name="nickname"/>
								<input type="hidden"  value="${currentInstallation.id}" name="ins"/>
								<input type="hidden"  value="${currentGraphType}" name="graphtype"/>
								<c:if test="${requiredISP != null}">
									<input type="hidden"  value="${requiredISP.id}" name="isp"/>
								</c:if>
					   			<input type="submit" class="btn btn-primary" value="Filtrar">
					   		</form>
		   			<div id="graphcontainer"></div><!-- Here the graph will be rendered -->
					<hr>
			        <div class="row" style="margin: 10 0 20 0;">
						<div class="text-center">
							<p>
								<img src="<c:url value='/img/congestiondown.png'/>"/> Congestion Upstream <img src="<c:url value='/img/congestionup.png'/>"/> Congestion Downstream
							</p>
								Location: ${currentInstallation.location.translationKey}
							<p>
							</p>
						</div>
						<div class="">
						</div>
					</div>
					<div class="hero-unit" style="z-index: 1;height: 53px;margin: 0px;padding: 0px;">
			        <div class="row" style="margin-top: 10px; margin-bottom:20px;">
						<div class="text-center">
									<c:choose>
										<c:when test="${requiredISP == null}">
											<a class="btn btn-primary"
										href="./dashboard?nickname=${user.nickname}&graphtype=GENERAL_GRAPH&ins=${currentInstallation.id}">General</a>
											<a class="btn btn-primary"
										href="./dashboard?nickname=${user.nickname}&graphtype=UPSTREAM_GRAPH&ins=${currentInstallation.id}">Upstream</a>
											<a class="btn btn-primary"
										href="./dashboard?nickname=${user.nickname}&graphtype=DOWNSTREAM_GRAPH&ins=${currentInstallation.id}">Downstream</a>
										</c:when>
										<c:otherwise>
											<a class="btn btn-primary"
										href="./dashboard?nickname=${user.nickname}&graphtype=GENERAL_GRAPH&ins=${currentInstallation.id}&isp=${requiredISP.id}">General</a>
											<a class="btn btn-primary"
										href="./dashboard?nickname=${user.nickname}&graphtype=UPSTREAM_GRAPH&ins=${currentInstallation.id}&isp=${requiredISP.id}">Upstream</a>
											<a class="btn btn-primary"
										href="./dashboard?nickname=${user.nickname}&graphtype=DOWNSTREAM_GRAPH&ins=${currentInstallation.id}&isp=${requiredISP.id}">Downstream</a>
										</c:otherwise>
									</c:choose>
								</div><!-- Graph buttons -->
					</div>
					</div>

        		</c:otherwise>
	        </c:choose>	
		
        </div><!--/span-->
      </div><!--/row-->
    
	</div>
	<%@ include file="/WEB-INF/jsp/footer.jsp"%>
</body>
<script type="text/javascript">                        
            $(function () {
            	 var datos =  ${javaChart.JSONString};
                 var fechas = ${javaChart.timestamps};
                 var title = "${javaChart.title}";
                 var redmarker = ${javaChart.redmarker};
                 var subtitle = "${javaChart.subtitle}";
                for (var i=0;i<fechas.length;i++){
                	fechas[i] = new Date(fechas[i]);
                }
                var chart;
                $(document).ready(function() {
                    chart = new Highcharts.Chart({
                        chart: {
                            renderTo: 'graphcontainer',
                          	marginRight: 130,
                           	marginBottom: 25
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
                            max: 144,
                            plotBands: redmarker, 
                            categories: fechas,
                            labels: {
                            	enabled: false,
                                formatter: function() {
                                    return Highcharts.dateFormat('%d/%m (%H:%M)', this.value);
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
                    point: {
                        events: {
                            click: function() {
                                $.holdReady(true); 
                                $.get("./changeCongestionStatus?id=" + this.id + "&type=" + this.type, function() {
								  $.holdReady(false);
								});
                              //  $.sleep(800);    
							//	$(location).attr('href', $(location).attr('href')).delay(2000);
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
                            enabled: true
                        },
                        series: datos
                    });
                });
            });
        
        </script>
<script type="text/javascript">
        var nowTemp = new Date();
var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
 
var checkin = $('#dpd1').datepicker({
  format: 'dd/mm/yyyy',
  onRender: function(date) {
    return date.valueOf() > now.valueOf() ? 'disabled' : '';
  }
}).on('changeDate', function(ev) {
  if (ev.date.valueOf() > checkout.date.valueOf()) {
    var newDate = new Date(ev.date)
    newDate.setDate(newDate.getDate() + 1);
    checkout.setValue(newDate);
  }
  checkin.hide();
  $('#dpd2')[0].focus();
}).data('datepicker');
var checkout = $('#dpd2').datepicker({
format: 'dd/mm/yyyy',
  onRender: function(date) {
    return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';
  }
}).on('changeDate', function(ev) {
  checkout.hide();
}).data('datepicker');

</script>

</html>