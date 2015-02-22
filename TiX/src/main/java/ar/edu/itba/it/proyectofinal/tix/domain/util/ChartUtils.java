package ar.edu.itba.it.proyectofinal.tix.domain.util;

import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import org.joda.time.DateTime;
import org.joda.time.DateTimeUtils;
import org.json.JSONArray;
import org.json.JSONObject;

import ar.edu.itba.it.proyectofinal.tix.domain.model.Record;

public class ChartUtils {

	public static List<Double> generateMedians(List<Record> records) {
		Iterator<Record> it = records.iterator();

		List<Double> medians = new ArrayList<Double>();

		// medians[0] congestion up
		// medians[1] congestion down
		// medians[2] utilizacion up
		// medians[3] utilizacion down

		List<Double> congestionup_values = new ArrayList<Double>();
		List<Double> congestiondown_values = new ArrayList<Double>();
		List<Double> utilizacionup_values = new ArrayList<Double>();
		List<Double> utilizaciondown_values = new ArrayList<Double>();

		int i = 0;
		while (it.hasNext()) {
			Record record = it.next();
			double congestionup = record.getCalidadUp();
			double congestiondown = record.getCalidadDown();
			double utilizacionup = record.getUtilizacionUpstream();
			double utilizaciondown = record.getUtilizacionDownstream();

			// values
			congestionup_values.add(congestionup);
			congestiondown_values.add(congestiondown);
			utilizacionup_values.add(utilizacionup);
			utilizaciondown_values.add(utilizaciondown);

			i++;
		}

		// sorting
		Collections.sort(congestionup_values);
		Collections.sort(congestiondown_values);
		Collections.sort(utilizacionup_values);
		Collections.sort(utilizaciondown_values);

		boolean even = (i % 2 == 0) ? true : false;

		// medians

		if (i > 4) {
			if (congestionup_values.size() != 0
					&& congestiondown_values.size() != 0
					&& utilizacionup_values.size() != 0
					&& utilizaciondown_values.size() != 0) {
				medians.add(
						0,
						even ? congestionup_values.get(i / 2)
								: ((congestionup_values.get((i / 2) - 1) + congestionup_values
										.get((i / 2) + 1))) / 2);
				medians.add(
						1,
						!even ? congestiondown_values.get(i / 2)
								: ((congestiondown_values.get((i / 2) - 1) + congestiondown_values
										.get((i / 2) + 1))) / 2);
				medians.add(
						2,
						!even ? utilizacionup_values.get(i / 2)
								: ((utilizacionup_values.get((i / 2) - 1) + utilizacionup_values
										.get((i / 2) + 1))) / 2);
				medians.add(
						3,
						!even ? utilizaciondown_values.get(i / 2)
								: ((utilizaciondown_values.get((i / 2) - 1) + utilizaciondown_values
										.get((i / 2) + 1))) / 2);
			}
		}

		return medians;
	}

	public static List<double[]> generateBoxplot(List<Record> records) {

		Iterator<Record> it = records.iterator();
		// [0] minimum
		// [1] lower quartile
		// [2] median
		// [3] higher quartile
		// [4] maximum

		double[] congestionup_vec = new double[5];
		double[] congestiondown_vec = new double[5];
		double[] utilizacionup_vec = new double[5];
		double[] utilizaciondown_vec = new double[5];
		double[] occurrences = new double[1]; // gives the number of occurrences in the boxplot 

		List<double[]> values = new ArrayList<double[]>();

		if (records.size() == 0) {
			return values;
		}

		// values
		List<Double> congestionup_values = new ArrayList<Double>();
		List<Double> congestiondown_values = new ArrayList<Double>();
		List<Double> utilizacionup_values = new ArrayList<Double>();
		List<Double> utilizaciondown_values = new ArrayList<Double>();

		int i = 0;
		while (it.hasNext()) {
			Record record = it.next();
			double congestionup = record.getCalidadUp();
			double congestiondown = record.getCalidadDown();
			double utilizacionup = record.getUtilizacionUpstream();
			double utilizaciondown = record.getUtilizacionDownstream();

			// minimums
			congestionup_vec[0] = (congestionup < congestionup_vec[0]) ? congestionup
					: congestionup_vec[0];
			congestiondown_vec[0] = (congestiondown < congestiondown_vec[0]) ? congestiondown
					: congestiondown_vec[0];
			utilizacionup_vec[0] = (utilizacionup < utilizacionup_vec[0]) ? utilizacionup
					: utilizacionup_vec[0];
			utilizaciondown_vec[0] = (utilizaciondown < utilizaciondown_vec[0]) ? utilizaciondown
					: utilizaciondown_vec[0];

			// maximums
			congestionup_vec[4] = (congestionup > congestionup_vec[4]) ? congestionup
					: congestionup_vec[4];
			congestiondown_vec[4] = (congestiondown > congestiondown_vec[4]) ? congestiondown
					: congestiondown_vec[4];
			utilizacionup_vec[4] = (utilizacionup > utilizacionup_vec[4]) ? utilizacionup
					: utilizacionup_vec[4];
			utilizaciondown_vec[4] = (utilizaciondown > utilizaciondown_vec[4]) ? utilizaciondown
					: utilizaciondown_vec[4];

			// values
			// System.out.println("congestionup:" + congestionup);
			// System.out.println("i: " + i);
			congestionup_values.add(congestionup);
			congestiondown_values.add(congestiondown);
			utilizacionup_values.add(utilizacionup);
			utilizaciondown_values.add(utilizaciondown);

			i++;
		}

		occurrences[0] = (double)i;
		
		// sorting
		Collections.sort(congestionup_values);
		Collections.sort(congestiondown_values);
		Collections.sort(utilizacionup_values);
		Collections.sort(utilizaciondown_values);

		// System.out.println("SORTED LIST: " + utilizacionup_values);

		boolean even = (i % 2 == 0) ? true : false;

		System.out.println("The value of the index is:" + i);
		System.out.println("congestionup_values:" + congestionup_values);

		// medians
		if (i == 2) {
			congestionup_vec[2] = (congestionup_values.get(0) + congestionup_values
					.get(1)) / 2;
			congestiondown_vec[2] = (congestiondown_values.get(0) + congestiondown_values
					.get(1)) / 2;
			utilizacionup_vec[2] = (utilizacionup_values.get(0) + utilizacionup_values
					.get(1)) / 2;
			utilizaciondown_vec[2] = (utilizaciondown_values.get(0) + utilizaciondown_values
					.get(1)) / 2;
		} else {
			congestionup_vec[2] = !even ? congestionup_values.get(i / 2)
					: ((congestionup_values.get((i / 2) - 1) + congestionup_values
							.get((i / 2) + 1))) / 2;
			congestiondown_vec[2] = !even ? congestiondown_values.get(i / 2)
					: ((congestiondown_values.get((i / 2) - 1) + congestiondown_values
							.get((i / 2) + 1))) / 2;
			utilizacionup_vec[2] = !even ? utilizacionup_values.get(i / 2)
					: ((utilizacionup_values.get((i / 2) - 1) + utilizacionup_values
							.get((i / 2) + 1))) / 2;
			utilizaciondown_vec[2] = !even ? utilizaciondown_values.get(i / 2)
					: ((utilizaciondown_values.get((i / 2) - 1) + utilizaciondown_values
							.get((i / 2) + 1))) / 2;
		}

		if (i != 2 && i > 4) {
			// lower quartiles
			congestionup_vec[1] = even ? congestionup_values.get(i / 4)
					: ((congestionup_values.get((i / 4) - 1) + congestionup_values
							.get((i / 4) + 1))) / 2;
			congestiondown_vec[1] = even ? congestiondown_values.get(i / 4)
					: ((congestiondown_values.get((i / 4) - 1) + congestiondown_values
							.get((i / 4) + 1))) / 2;
			utilizacionup_vec[1] = even ? utilizacionup_values.get(i / 4)
					: ((utilizacionup_values.get((i / 4) - 1) + utilizacionup_values
							.get((i / 4) + 1))) / 2;
			utilizaciondown_vec[1] = even ? utilizaciondown_values.get(i / 4)
					: ((utilizaciondown_values.get((i / 4) - 1) + utilizaciondown_values
							.get((i / 4) - 1))) / 2;

			// higher quartiles
			congestionup_vec[3] = even ? congestionup_values.get(i / 4 * 3)
					: ((congestionup_values.get(i / 4 * 3) - 1) + congestionup_values
							.get((i / 4 * 3) + 1)) / 2;
			congestiondown_vec[3] = even ? congestiondown_values.get(i / 4 * 3)
					: ((congestiondown_values.get(i / 4 * 3) - 1) + congestiondown_values
							.get((i / 4 * 3) + 1)) / 2;
			utilizacionup_vec[3] = even ? utilizacionup_values.get(i / 4 * 3)
					: ((utilizacionup_values.get(i / 4 * 3) - 1) + utilizacionup_values
							.get((i / 4 * 3) + 1)) / 2;
			utilizaciondown_vec[3] = even ? utilizaciondown_values
					.get(i / 4 * 3)
					: ((utilizaciondown_values.get(i / 4 * 3) - 1) + utilizaciondown_values
							.get((i / 4 * 3) - 1)) / 2;

		}

		if (congestionup_vec[2] > congestionup_vec[3] ){
			congestionup_vec[2] = congestionup_vec[3];
		}
		if (congestiondown_vec[2] > congestiondown_vec[3] ){
			congestiondown_vec[2] = congestiondown_vec[3];
		}
		if (utilizacionup_vec[2] > utilizacionup_vec[3] ){
			utilizacionup_vec[2] = utilizacionup_vec[3];
		}
		if (utilizaciondown_vec[2] > utilizaciondown_vec[3] ){
			utilizaciondown_vec[2] = utilizaciondown_vec[3];
		}
		
		if (congestionup_vec[2] < congestionup_vec[1] ){
			congestionup_vec[1] = congestionup_vec[2];
		}
		if (congestiondown_vec[2] < congestiondown_vec[1] ){
			congestiondown_vec[1] = congestiondown_vec[2];
		}
		if (utilizacionup_vec[2] < utilizacionup_vec[1] ){
			utilizacionup_vec[1] = utilizacionup_vec[2];
		}
		if (utilizaciondown_vec[2] < utilizaciondown_vec[1] ){
			utilizaciondown_vec[1] = utilizaciondown_vec[2];
		}
		
				// printVec(congestionup_vec);
		// printVec(congestiondown_vec);
		// printVec(utilizacionup_vec);
		// printVec(utilizaciondown_vec);
		//
		
		for (int k =0; k<5;k++){
			 DecimalFormat df = new DecimalFormat("#.00");
			 congestionup_vec[k] = Double.parseDouble( df.format(congestionup_vec[k]));
			 congestiondown_vec[k] = Double.parseDouble( df.format(congestiondown_vec[k]));
			 utilizacionup_vec[k] = Double.parseDouble( df.format(utilizacionup_vec[k]));
			 utilizaciondown_vec[k] = Double.parseDouble( df.format(utilizaciondown_vec[k]));
		}

		values.add(congestionup_vec);
		values.add(congestiondown_vec);
		values.add(utilizacionup_vec);
		values.add(utilizaciondown_vec);
		values.add(occurrences);

		return values;
	}

	// private static void printVec(double a[] ){
	// System.out.println("TESTING [ " + a[0] +"   "+ a[1] +"   "+ a[2] +"   "+
	// a[3] +"   "+ a[4] +"]");
	// }

	// Histograms
	public static int[] generateHistogramCongestionUp(List<Record> records,
			String title) {
		Iterator<Record> it = records.iterator();
		int[] classes = new int[11];
		while (it.hasNext()) {
			Record record = it.next();
			double index = record.getCalidadUp() / 10;
			int cong = (int) index;
			if (cong == 10) {
        cong--;
      }
      classes[cong]++;
		}
		return classes;
	}

	public static int[] generateHistogramCongestionDown(List<Record> records,
			String title) {
		Iterator<Record> it = records.iterator();
		int[] classes = new int[11];
		while (it.hasNext()) {
			Record record = it.next();
			double index = record.getCalidadDown() / 10;
			int cong = (int) index;
			if (cong == 10) {
        cong--;
      }
      classes[cong]++;
		}
		return classes;
	}

	public static int[] generateHistogramUtilizacionUp(List<Record> records,
			String title) {
		Iterator<Record> it = records.iterator();
		int[] classes = new int[10];
		while (it.hasNext()) {
			Record record = it.next();
			double index = record.getUtilizacionUpstream() / 10;
			int cong = (int) index;
			if (cong == 10) {
        cong--;
      }
      classes[cong]++;
		}
		return classes;
	}

	public static int[] generateHistogramUtilizacionDown(List<Record> records,
			String title) {
		Iterator<Record> it = records.iterator();
		int[] classes = new int[10];
		while (it.hasNext()) {
			Record record = it.next();
			double index = record.getUtilizacionDownstream() / 10;
			int cong = (int) index;
			if (cong == 10) {
        cong--;
      }
      classes[cong]++;
		}
		return classes;
	}

	public static HighChart generateHighChart(List<Record> records,
			String title, String subtitle, ChartType graphType) {

		float UTIlIZACION_VALUE = (float) 80;
		String json = null;
		List<Long> timestamps = new ArrayList<Long>();
		HighChart chart = null;
		try {
			JSONArray js = new JSONArray();
			JSONArray utilizacionup_js = new JSONArray();
			JSONArray utilizaciondown_js = new JSONArray();
			JSONArray utilizacion_js = new JSONArray();
			JSONArray utilizacion_final = new JSONArray();
			ArrayList<String> metricas;
			metricas = new ArrayList<String>();
			switch (graphType) {
			case UPSTREAM_GRAPH:
				metricas.add("CalidadUp");
				metricas.add("UtilizacionUp");
				break;
			case DOWNSTREAM_GRAPH:
				metricas.add("CalidadDown");
				metricas.add("UtilizacionDown");
				break;
			default:
				metricas.add("CalidadUp");
				metricas.add("UtilizacionUp");
				metricas.add("CalidadDown");
				metricas.add("UtilizacionDown");
				break;
			}

			List<Float> downStream = new ArrayList<Float>();
			List<Float> utilizacionDown = new ArrayList<Float>();
			List<Object> upStream = new ArrayList<Object>();
			List<Float> utilizacionUp = new ArrayList<Float>();
			List<HighchartPoint> highchartPoints = new ArrayList<HighchartPoint>();
			List<List<Long>> points = new ArrayList<List<Long>>();

			Iterator<Record> it = records.iterator();
			long aux_timestamp = -1;
			JSONObject j;
			JSONObject upStream_json = new JSONObject();
			JSONArray upStream_array = new JSONArray();
			JSONObject downStream_json = new JSONObject();
			JSONArray downStream_array = new JSONArray();
			boolean jump;
			while (it.hasNext()) {
				jump = false;
				Record record = it.next();
				DateTime dt = new DateTime(record.getTimestamp());
				// System.out.println("Salida: " + (aux_timestamp -
				// dt.getMillis()));
				// 20 minutos de de margen entre punto y punto
				if (aux_timestamp > 0
						&& (aux_timestamp - dt.getMillis()) < -(60 * 20 * 1000)) {
					jump = true;
					timestamps.add((aux_timestamp - dt.getMillis()) / 2);
					// System.out.println("ENTRO");
				}
				if (record.isUserDownCongestion()) {
					if (jump == true) {
						downStream_json = new JSONObject();
						downStream_json.put("y", -1);
						downStream_json.put("id", record.getId());
						downStream_json.put("type", "D");
						downStream_json
								.put("marker",
										new JSONObject()
												.put("symbol",
														"url(http://www.highcharts.com/demo/gfx/sun.png)"));
						downStream_array.put(downStream_json);
					}
					downStream_json = new JSONObject();
					downStream_json.put("y", record.getDownstream());
					downStream_json.put("id", record.getId());
					downStream_json.put("type", "D");
					downStream_json.put("marker", new JSONObject().put(
							"symbol",
							"url(http://www.highcharts.com/demo/gfx/sun.png)"));
					downStream_array.put(downStream_json);
				} else {
					if (jump == true) {
						downStream_json = new JSONObject();
						downStream_json.put("y", -1);
						downStream_json.put("id", record.getId());
						downStream_json.put("type", "D");
						downStream_array.put(downStream_json);
					}
					downStream_json = new JSONObject();
					downStream_json.put("y", record.getDownstream());
					downStream_json.put("id", record.getId());
					downStream_json.put("type", "D");
					downStream_array.put(downStream_json);
				}

				if (record.isUserUpCongestion()) {
					if (jump == true) {
						upStream_json = new JSONObject();
						upStream_json.put("y", -1);
						upStream_json.put("id", record.getId());
						upStream_json.put("type", "U");
						upStream_json
								.put("marker",
										new JSONObject()
												.put("symbol",
														"url(http://www.highcharts.com/demo/gfx/sun.png)"));
						upStream_array.put(upStream_json);
					}
					upStream_json = new JSONObject();
					upStream_json.put("y", record.getUpstream());
					upStream_json.put("id", record.getId());
					upStream_json.put("type", "U");
					upStream_json.put("marker", new JSONObject().put("symbol",
							"url(http://www.highcharts.com/demo/gfx/sun.png)"));
					upStream_array.put(upStream_json);
				} else {
					if (jump == true) {
						upStream_json = new JSONObject();
						upStream_json.put("y", -1);
						upStream_json.put("id", record.getId());
						upStream_json.put("type", "U");
						upStream_array.put(upStream_json);
					}
					upStream_json = new JSONObject();
					upStream_json.put("y", record.getUpstream());
					upStream_json.put("id", record.getId());
					upStream_json.put("type", "U");
					upStream_array.put(upStream_json);
					// upStream.add(record.getUpstream());
				}
				// System.out.println(upStream_array);
				if (jump == true) {
					utilizacionDown.add(new Float(-1));
					utilizacionUp.add(new Float(-1));
				}
				utilizacionDown.add(record.getUtilizacionDownstream());
				utilizacionUp.add(record.getUtilizacionUpstream());
				aux_timestamp = dt.getMillis();
				timestamps.add(dt.getMillis());
				List<Long> point = new ArrayList<Long>();
				point.add((DateTimeUtils.getInstantMillis(dt)));
				point.add((long) record.getUtilizacionUpstream());
				points.add(point);
			}
			int i = 0;
			for (Float valor : utilizacionUp) {
				if (valor > UTIlIZACION_VALUE && i > 0) {
					JSONObject a;
					a = new JSONObject();
					a.put("from", i - 1);
					a.put("to", i);
					a.put("color", "rgba(255, 0, 0, .25)");
					utilizacionup_js.put(a);
					utilizacion_js.put(a);
				}
				i++;
			}
			i = 0;

			for (Float valor : utilizacionDown) {
				if (valor > UTIlIZACION_VALUE && i > 0) {
					JSONObject a;
					a = new JSONObject();
					a.put("from", i - 1);
					a.put("to", i);
					a.put("color", "rgba(0, 125, 125, .25)");
					utilizaciondown_js.put(a);
					utilizacion_js.put(a);
				}
				i++;
			}

			JSONObject lineMarkerOptions = new JSONObject();
			lineMarkerOptions.put("symbol", "circle");
			JSONObject utilizacionMarkerOptions = new JSONObject();
			// congestionMarkerOptions.put("radius", 7);
			utilizacionMarkerOptions.put("symbol", "diamond");

			switch (graphType) {
			case UPSTREAM_GRAPH:
				j = new JSONObject();
				j.put("name", metricas.get(0));
				// j.put("data", upStream);
				j.put("data", upStream_array);
				j.put("marker", lineMarkerOptions);
				// System.out.println(j.get("data"));
				js.put(j);
				j = new JSONObject();
				j.put("name", metricas.get(1));
				j.put("data", utilizacionUp);
				j.put("marker", utilizacionMarkerOptions);
				js.put(j);
				utilizacion_final = utilizacionup_js;
				break;
			case DOWNSTREAM_GRAPH:
				j = new JSONObject();
				j.put("name", metricas.get(0));
				j.put("data", downStream_array);
				j.put("marker", lineMarkerOptions);
				js.put(j);
				j = new JSONObject();
				j.put("name", metricas.get(1));
				j.put("data", utilizacionDown);
				j.put("marker", utilizacionMarkerOptions);
				js.put(j);
				utilizacion_final = utilizaciondown_js;
				break;
			default:
				j = new JSONObject();
				j.put("name", metricas.get(0));
				j.put("data", upStream_array);
				j.put("marker", lineMarkerOptions);
				js.put(j);
				j = new JSONObject();
				j.put("name", metricas.get(1));
				j.put("data", utilizacionUp);
				j.put("marker", utilizacionMarkerOptions);
				js.put(j);
				j = new JSONObject();
				j.put("name", metricas.get(2));
				j.put("data", downStream_array);
				j.put("marker", lineMarkerOptions);
				js.put(j);
				j = new JSONObject();
				j.put("name", metricas.get(3));
				j.put("data", utilizacionDown);
				j.put("marker", utilizacionMarkerOptions);
				js.put(j);
				utilizacion_final = utilizacion_js;
			}

			chart = new HighChart(timestamps, js, title, subtitle,
					utilizacion_final);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		return chart;
	}

}
