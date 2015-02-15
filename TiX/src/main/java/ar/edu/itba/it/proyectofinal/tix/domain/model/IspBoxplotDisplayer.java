package ar.edu.itba.it.proyectofinal.tix.domain.model;

import java.util.Arrays;

public class IspBoxplotDisplayer {

	private String isp_name;
	private int isp_id;
	private int occurrences;
	private double[] congestionUpChart = null;
	private double[] congestionDownChart = null;
	private double[] utilizacionUpChart = null;
	private double[] utilizacionDownChart = null;
	
	public IspBoxplotDisplayer() {
		super();
	}

	public String getIsp_name() {
		return isp_name;
	}

	public void setIsp_name(String isp_name) {
		this.isp_name = isp_name;
	}

	public int getIsp_id() {
		return isp_id;
	}

	public void setIsp_id(int isp_id) {
		this.isp_id = isp_id;
	}
	
	public int getOccurrences() {
		return occurrences;
	}

	public void setOccurrences(int occurrences) {
		this.occurrences = occurrences;
	}

	public double[] getCongestionUpChart() {
		return congestionUpChart;
	}

	public void setCongestionUpChart(double[] congestionUpChart) {
		this.congestionUpChart = congestionUpChart;
	}

	public double[] getCongestionDownChart() {
		return congestionDownChart;
	}

	public void setCongestionDownChart(double[] congestionDownChart) {
		this.congestionDownChart = congestionDownChart;
	}

	public double[] getUtilizacionUpChart() {
		return utilizacionUpChart;
	}

	public void setUtilizacionUpChart(double[] utilizacionUpChart) {
		this.utilizacionUpChart = utilizacionUpChart;
	}

	public double[] getUtilizacionDownChart() {
		return utilizacionDownChart;
	}

	public void setUtilizacionDownChart(double[] utilizacionDownChart) {
		this.utilizacionDownChart = utilizacionDownChart;
	}

	@Override
	public String toString() {
		return "IspBoxplotDisplayer [isp_name=" + isp_name + ", isp_id="
				+ isp_id + ", congestionUpChart="
				+ Arrays.toString(congestionUpChart) + ", congestionDownChart="
				+ Arrays.toString(congestionDownChart)
				+ ", utilizacionUpChart=" + Arrays.toString(utilizacionUpChart)
				+ ", utilizacionDownChart="
				+ Arrays.toString(utilizacionDownChart) + "]";
	}
	
	
}
