<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@
taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
<title>Graficos de utilizacion y calidad</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<!-- CSS bootstrap styles -->
<link href="<c:url value='/css/bootstrap.css'/>" rel="stylesheet">
<!-- CSS Datepicker styles -->
<link href="<c:url value='/css/datepicker.css'/>" rel="stylesheet">
<link href="<c:url value='/css/tix.css'/>" rel="stylesheet">

<!-- required for histograms -->
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.js"></script>
<script type="text/javascript" src="http://code.highcharts.com/highcharts.js"></script>

<script src="http://code.jquery.com/jquery-1.10.1.min.js"></script>
<script type="text/javascript" src="<c:url value='/js/bootstrap.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/bootstrap-datepicker.js'/>"></script>
<script src="http://code.highcharts.com/stock/highstock.js"></script>
<script src="<c:url value='/js/tix.js'/>"></script>


<!-- required for boxplots -->
<script src="http://code.highcharts.com/highcharts-more.js"></script>
<script src="http://code.highcharts.com/modules/exporting.js"></script>
<!-- <link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
 --></head>

<body>
<%@ include file="/WEB-INF/jsp/header.jsp"%>

<br/><br/>

<div class="span12">

    <form method="GET"  action="./ispcharts" class="form-horizontal offset2" style="height:220px;">

        <div class="input-prepend" data-date-format="dd-mm-yyyy">
            <span class="add-on"><i class="icon-calendar"></i></span>
                <input type="text" class="span8" value="${minDate}" name="minDate" id="dpd1" placeholder="Fecha desde"/>
        </div>
        <div class="input-prepend" data-date-format="dd-mm-yyyy">
            <span class="add-on"><i class="icon-calendar"></i></span>
                <input type="text" class="span8" value="${maxDate}" name="maxDate" id="dpd2" placeholder="Fecha hasta"/>
        </div>
        <c:if test="${requiredISP != null}">
            <input type="hidden"  value="${requiredISP.id}" name="isp"/>
        </c:if>

        <div class="control-group pull-left">
          <label class="control-label" for="dayOfWeek">Dia de la semana</label>
          <div class="controls">
            <select id="dayOfWeek" name="dayOfWeek" class="input-xlarge">
              <option value="0" <c:if test="${dayOfWeek == 0}">selected</c:if> >Todos</option>
              <option value="1" <c:if test="${dayOfWeek == 1}">selected</c:if>>Lunes</option>
              <option value="2" <c:if test="${dayOfWeek == 2}">selected</c:if>>Martes</option>
              <option value="3" <c:if test="${dayOfWeek == 3}">selected</c:if>>Miercoles</option>
              <option value="4" <c:if test="${dayOfWeek == 4}">selected</c:if>>Jueves</option>
              <option value="5" <c:if test="${dayOfWeek == 5}">selected</c:if>>Viernes</option>
              <option value="6" <c:if test="${dayOfWeek == 6}">selected</c:if>>Sabado</option>
              <option value="7" <c:if test="${dayOfWeek == 7}">selected</c:if>>Domingo</option>
            </select>
          </div>
        </div>

        <div class="pull-left">
            <label class="control-label" for="minHour">Hora de comienzo</label>
            <div class="controls">
                <input type="text" name="minHour" id="minHour" placeholder="ejemplo: 8" value='<c:if test="${maxHour > minHour}">${minHour}</c:if>' />
            </div>
        </div>
        <div class="pull-left">
	        <label class="control-label" for="maxHour">Hora de fin</label>
            <div class="controls">
                <input type="text" name="maxHour" id="maxHour" placeholder="ejemplo: 22" value='<c:if test="${maxHour > minHour}">${maxHour}</c:if>'/>
            </div>
          </div>
        <div class="pull-right">
            <input type="submit" class="btn btn-primary pull-left pull-down" value="Filtrar">
        </div>



    </form>
</div>

<!-- <div class="span3">
<form method="GET"  action="./adminreport" class="form-horizontal offset2" style="padding-left:10px;">
    <input type="submit" class="btn btn-primary" value="Generar PDF">
</form>
</div> -->

<br/><br/><br/><br/>


<c:forEach items="${disp_list}" var="entry">
    <div class="isp-container row-fluid" style="margin: 50px 50px 20px 100px; height:600px;">
        <h3 class="isp-name">${entry.isp_name}</h3>
            <!-- calidad -->
            <div class="row-fluid span8" style="width:1000px">
                <div id="congestionup${entry.isp_id}" class="pull-left" style="height: 300px; width: 465px"></div>
                <div id="congestiondown${entry.isp_id}" class="pull-right" style="height: 300px; width: 465px"></div>
            </div>

            <!-- Utilizacion -->
            <div class="row-fluid span8" style="width:1000px; background-color:#FCFCFC">
                <div id="utilizacionup${entry.isp_id}" class="pull-left" style="height: 300px; width: 465px"></div>
                <div id="utilizaciondown${entry.isp_id}" class="pull-right" style="height: 300px; width: 465px"></div>
            </div>
    </div>
    <hr/>
</c:forEach>
<c:forEach items="${boxplot_list}" var="entry">
    <h3 class="isp-name" style="margin-left:180px;">${entry.isp_name} ( ${entry.occurrences} ocurrencias )</h3>
    <div id="container${entry.isp_id}" style="height: 400px; margin: auto; min-width: 310px; max-width: 600px"></div>
    <br/>
</c:forEach>




<!-- Data de los histogramas -->
<c:forEach items="${disp_list}" var="entry">
    <script type="text/javascript">
        var chart = new Highcharts.Chart({
            chart: {
                renderTo: 'congestionup${entry.isp_id}',
                type: 'column'
            },
            title: {
                text: '<b>Calidad Subida</b>',
                x: -20 //center
            },

            xAxis: {
                categories: ['0-10%', '10-20%', '20-30%', '30-40%', '40-50%', '50-60%', '60-70%', '70-80%', '80-90%', '90-100%']
            },

            yAxis:{
            title:{text:'Ocurrencias'},

            },

            plotOptions: {
                column: {
                    groupPadding: 0,
                    pointPadding: 0,
                    borderWidth: 0
                }
            },

            series: [{
                name:'Calidad Subida',
                data: [${entry.congestionUpChart[0]}, ${entry.congestionUpChart[1]}, ${entry.congestionUpChart[2]}, ${entry.congestionUpChart[3]}, ${entry.congestionUpChart[4]}, ${entry.congestionUpChart[5]}, ${entry.congestionUpChart[6]}, ${entry.congestionUpChart[7]}, ${entry.congestionUpChart[8]}, ${entry.congestionUpChart[9]}]
            }]

        });
    var chart = new Highcharts.Chart({

        chart: {
            renderTo: 'congestiondown${entry.isp_id}',
            type: 'column'
        },
        title: {
            text: '<b>Calidad Bajada</b>',
            x: -20 //center
        },

        xAxis: {
            categories: ['0-10%', '10-20%', '20-30%', '30-40%', '40-50%', '50-60%', '60-70%', '70-80%', '80-90%', '90-100%']
        },

        yAxis:{
            title:{text:'Ocurrencias'},
        },

        plotOptions: {
            column: {
                groupPadding: 0,
                pointPadding: 0,
                borderWidth: 0,
                color: '#E36262'

            }
        },

        series: [{
            name:'Calidad Bajada',
            data: [${entry.congestionDownChart[0]}, ${entry.congestionDownChart[1]}, ${entry.congestionDownChart[2]}, ${entry.congestionDownChart[3]}, ${entry.congestionDownChart[4]}, ${entry.congestionDownChart[5]}, ${entry.congestionDownChart[6]}, ${entry.congestionDownChart[7]}, ${entry.congestionDownChart[8]}, ${entry.congestionDownChart[9]}]
        }]

    });

    var chart = new Highcharts.Chart({

        chart: {
            renderTo: 'utilizacionup${entry.isp_id}',
            type: 'column',
            backgroundColor: '#FCFCFC'
        },
        title: {
            text: 'Utilizacion Subida',
            x: -20 //center
        },

        xAxis: {
            categories: ['0-10%', '10-20%', '20-30%', '30-40%', '40-50%', '50-60%', '60-70%', '70-80%', '80-90%', '90-100%']
        },

        yAxis:{
            title:{text:'Ocurrencias'},
        },

        plotOptions: {
            column: {
                groupPadding: 0,
                pointPadding: 0,
                borderWidth: 0
            }
        },

        series: [{
            name:'Utilizacion Subida',
            data: [${entry.utilizacionUpChart[0]}, ${entry.utilizacionUpChart[1]}, ${entry.utilizacionUpChart[2]}, ${entry.utilizacionUpChart[3]}, ${entry.utilizacionUpChart[4]}, ${entry.utilizacionUpChart[5]}, ${entry.utilizacionUpChart[6]}, ${entry.utilizacionUpChart[7]}, ${entry.utilizacionUpChart[8]}, ${entry.utilizacionUpChart[9]}]
        }]

    });

    var chart = new Highcharts.Chart({

        chart: {
            renderTo: 'utilizaciondown${entry.isp_id}',
            type: 'column',
            backgroundColor: '#FCFCFC'
        },
        title: {
            text: 'Utilizacion Bajada',
            x: -20 //center
        },

        xAxis: {
            categories: ['0-10%', '10-20%', '20-30%', '30-40%', '40-50%', '50-60%', '60-70%', '70-80%', '80-90%', '90-100%']
        },

        yAxis:{
            title:{text:'Ocurrencias'},
        },

        plotOptions: {
            column: {
                groupPadding: 0,
                pointPadding: 0,
                borderWidth: 0,
                color: '#E36262'
            }
        },

        series: [{
            name:'Utilizacion Bajada',
            data: [${entry.utilizacionDownChart[0]}, ${entry.utilizacionDownChart[1]}, ${entry.utilizacionDownChart[2]}, ${entry.utilizacionDownChart[3]}, ${entry.utilizacionDownChart[4]}, ${entry.utilizacionDownChart[5]}, ${entry.utilizacionDownChart[6]}, ${entry.utilizacionDownChart[7]}, ${entry.utilizacionDownChart[8]}, ${entry.utilizacionDownChart[9]}]
        }]

    });
    </script>

</c:forEach>


<!-- Data de los boxplots -->
<c:forEach items="${boxplot_list}" var="entry">
    <script>
    var chart = new Highcharts.Chart({

        chart: {
            renderTo: 'container${entry.isp_id}',
            type: 'boxplot'
        },

        title: {
            text: '${entry.isp_name}'
        },

        plotOptions: {
            series: {
                shadow:false,
                borderWidth:0,
                dataLabels:{
                    enabled:true,
                    formatter:function() {
                        return this.y + '%';
                    }
                }
            }
        },

        xAxis: {
            minTickInterval: 1,
            categories: ['<b>Calidad Subida</b>', '<b>Calidad Bajada</b>', 'Utilizacion Subida', 'Utilizacion Bajada']
        },

        yAxis:{
            title:{text:'Porcentaje'},
            max: 100,
            min:0,
            labels: {
                formatter:function() {
                    // var pcnt = (this.value / dataSum) * 100;
                    return Highcharts.numberFormat(this.value ,0,',') + '%';
                }
            }
        },

        series: [{
            name: '${entry.isp_name}',
            data: [
                [${entry.congestionUpChart[0]}, ${entry.congestionUpChart[1]}, ${entry.congestionUpChart[2]}, ${entry.congestionUpChart[3]}, ${entry.congestionUpChart[4]}],
                [${entry.congestionDownChart[0]}, ${entry.congestionDownChart[1]}, ${entry.congestionDownChart[2]}, ${entry.congestionDownChart[3]}, ${entry.congestionDownChart[4]}],
                [${entry.utilizacionUpChart[0]}, ${entry.utilizacionUpChart[1]}, ${entry.utilizacionUpChart[2]}, ${entry.utilizacionUpChart[3]}, ${entry.utilizacionUpChart[4]}],
                [${entry.utilizacionDownChart[0]}, ${entry.utilizacionDownChart[1]}, ${entry.utilizacionDownChart[2]}, ${entry.utilizacionDownChart[3]}, ${entry.utilizacionDownChart[4]}]
            ]
        }]

    });
    </script>
</c:forEach>



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


</body>

</html>
