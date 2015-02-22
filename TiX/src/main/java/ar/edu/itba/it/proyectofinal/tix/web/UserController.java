package ar.edu.itba.it.proyectofinal.tix.web;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TreeMap;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import ar.edu.itba.it.proyectofinal.tix.domain.model.ISP;
import ar.edu.itba.it.proyectofinal.tix.domain.model.Installation;
import ar.edu.itba.it.proyectofinal.tix.domain.model.IspBoxplotDisplayer;
import ar.edu.itba.it.proyectofinal.tix.domain.model.IspHistogramDisplayer;
import ar.edu.itba.it.proyectofinal.tix.domain.model.Record;
import ar.edu.itba.it.proyectofinal.tix.domain.model.User;
import ar.edu.itba.it.proyectofinal.tix.domain.model.UserType;
import ar.edu.itba.it.proyectofinal.tix.domain.repository.RecordRepository;
import ar.edu.itba.it.proyectofinal.tix.domain.repository.UserRepository;
import ar.edu.itba.it.proyectofinal.tix.domain.util.ChartType;
import ar.edu.itba.it.proyectofinal.tix.domain.util.ChartUtils;
import ar.edu.itba.it.proyectofinal.tix.domain.util.HighChart;
import ar.edu.itba.it.proyectofinal.tix.web.util.ControllerUtil;

@Controller
public class UserController {

	private UserRepository userRepo;
	private RecordRepository recordRepo;

	@Autowired
	public UserController(UserRepository userRepo, RecordRepository recordRepo) {
		this.userRepo = userRepo;
		this.recordRepo = recordRepo;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView adminpanel(HttpSession session) {
		ModelAndView mav = new ModelAndView();
		User me = getSessionUser(session);

		if (me == null) {
			mav.setView(ControllerUtil.redirectView("/login/login"));
			return mav;
		}

		if (!me.getType().equals(UserType.ADMIN)) {
			mav.addObject("errorDescription",
					"No tiene permisos para acceder aquí.");
			mav.setViewName("error");
			return mav;
		}
		List<? extends User> allUsersExceptAdmin = userRepo.getAll();
		allUsersExceptAdmin.remove(me);
				
		mav.addObject("userList", allUsersExceptAdmin);
		return mav;

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	@ResponseBody
	public String users(HttpSession session) {
		List<User> users = (List<User>) userRepo.getAll();
		String user_names = "";
		for (User u : users) {
			if (!u.getNickname().equals("admin@admin.com")) {
				user_names += u.getNickname() + ";";
			}
		}
		return user_names;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView home(HttpSession session) {
		ModelAndView mav = new ModelAndView();
		User me = getSessionUser(session);

		if (me == null) {
			mav.setView(ControllerUtil.redirectView("/login/"));
			return mav;
		}

		if (me.getType().equals(UserType.ADMIN)) {
			mav.setView(ControllerUtil.redirectView("/user/adminpanel"));
		} else {
			mav.setView(ControllerUtil.redirectView("/user/dashboard"));
		}
		return mav;

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public void  adminreport(HttpSession session, HttpServletResponse response) throws IOException, InterruptedException {
		Runtime rt = Runtime.getRuntime(); 
		String today= new DateTime().toString("dd-MM-yy", Locale.US);
		String reportname =  "adminreport" + today +".pdf";
		String reporturl = "http://localhost:8080/tix/bin/user/ispcharts";
		
		//creating cookie temp file
		String tmpname = "sid"+ RandomStringUtils.random(8, true, true);
		File temp = File.createTempFile(tmpname, ".jar"); 	
		if (temp.exists())
		{
			temp.delete();
		}
	    BufferedWriter bw = new BufferedWriter(new FileWriter(temp));	
	    bw.write("JSESSIONID=" + session.getId());
	    
	    bw.close();
				
//		Process p = rt.exec("wkhtmltopdf  "+ reporturl + " /home/pfitba/admin_reports/" + reportname ) ;
	    String ex = "/usr/local/bin/wkhtmltopdf --cookie-jar " +  temp.getPath() +" "+ reporturl + " " + reportname;
		Process p = rt.exec("/usr/local/bin/wkhtmltopdf --cookie-jar " +  temp.getPath() +" "+ reporturl + " " + reportname) ;
		System.out.println(ex);
		System.out.println("Waiting for Admin report: id " + 		session.getId() + temp.getPath());
		
		p.waitFor();
		
		System.out.println("Admin report done: " + reportname);
//	    File initialFile = new File("/home/pfitba/admin_reports/"+reportname);
	    File initialFile = new File(reportname);
	    InputStream targetStream = new FileInputStream(initialFile);
	    org.apache.commons.io.IOUtils.copy(targetStream, response.getOutputStream());
//	    response.flushBuffer();
	    
	    response.setContentType("application/pdf");
		
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView dashboard(
			HttpSession session,
			@RequestParam(value = "nickname", defaultValue = "") String nickname,
			@RequestParam(value = "graphtype", defaultValue = "GENERAL_GRAPH") ChartType graphtype,
			@RequestParam(value = "ins", required = false) Installation requiredInstallation,
			@RequestParam(value = "isp", required = false) ISP requiredISP,
			@RequestParam(value = "minDate", required = false) DateTime minDate,
			@RequestParam(value = "maxDate", required = false) DateTime maxDate,
			@RequestParam(value = "test", required = false) String test) {
		ModelAndView mav = new ModelAndView();

		User reqProfile = userRepo.get(nickname);
		User me = getSessionUser(session);

		if (reqProfile == null) {
			mav.setView(ControllerUtil.redirectView("/user/dashboard?nickname="
					+ me.getNickname() + "&graphtype=" + graphtype));
			return mav;
		} else if (!reqProfile.equals(me)
				&& !me.getType().equals(UserType.ADMIN)) {
			mav.addObject("errorDescription",
					"No tiene permisos para acceder aquí.");
			mav.setViewName("error");
			return mav;
		}

		List<Installation> userInstallations = reqProfile.getInstallations();

		if (userInstallations.isEmpty()) { // No installation or data to show
											// for current user
			mav.setView(ControllerUtil
					.redirectView("/installation/downloadapp"));
			return mav;
		}
		Map<Installation, List<ISP>> installationISPMap = new HashMap<Installation, List<ISP>>();

		for (Installation i : userInstallations) {
			List<ISP> ispsForInstallation = recordRepo.getISPsForInstallation(
					reqProfile, i);
			Collections.sort(ispsForInstallation, new Comparator<ISP>() {
				public int compare(ISP o1, ISP o2) {
					return o1.getName().compareTo(o2.getName());
				}
			});
			installationISPMap.put(i, ispsForInstallation);
		}

		ValueComparator bvc = new ValueComparator(installationISPMap);
		TreeMap<Installation, List<ISP>> sorted_map = new TreeMap<Installation, List<ISP>>(
				bvc);
		sorted_map.putAll(installationISPMap);

		List<ISP> ispDefaultInstallations = sorted_map.get(reqProfile
				.getDefaultInstallation());

		mav.addObject("ispDefaultInstallations", ispDefaultInstallations);

		mav.addObject("installationISPMap", sorted_map);

		if (requiredInstallation == null) { // URL param "ins" not found, set
											// default installation
			requiredInstallation = reqProfile.getDefaultInstallation();
		}

		HighChart chart = null;

		if (graphtype == null) {
			graphtype = ChartType.GENERAL_GRAPH;
		}

		List<Record> records;

		if (requiredISP == null) { // No specified ISP, get all records
			records = (List<Record>) recordRepo.getAll(reqProfile,
					requiredInstallation, minDate, maxDate);
		} else {
			records = (List<Record>) recordRepo.getAllForISP(reqProfile,
					requiredInstallation, requiredISP, minDate, maxDate);
		}

		boolean noRecords = false;
		if (records.isEmpty()) {
			noRecords = true;
		} else {
			switch (graphtype) {
			case UPSTREAM_GRAPH:
				chart = ChartUtils
						.generateHighChart(
								records,
								"Porcentaje de Utilización de Ancho de Banda en "
										+ requiredInstallation.getName()
										+ ((requiredISP == null) ? "" : " ["
												+ requiredISP.getName() + "]"),
								"Gráfico del Upstream para "
										+ reqProfile.getNickname()
										+ ((minDate != null && maxDate != null) ? " ("
												+ getFormattedDate(minDate)
												+ " - "
												+ getFormattedDate(maxDate)
												+ ")"
												: ""),

								ChartType.UPSTREAM_GRAPH);
				break;
			case DOWNSTREAM_GRAPH:
				chart = ChartUtils
						.generateHighChart(
								records,
								"Porcentaje de Utilización de Ancho de Banda en "
										+ requiredInstallation.getName()
										+ ((requiredISP == null) ? "" : " ["
												+ requiredISP.getName() + "]"),
								"Gráfico del Downstream para "
										+ reqProfile.getNickname()
										+ ((minDate != null && maxDate != null) ? " ("
												+ getFormattedDate(minDate)
												+ " - "
												+ getFormattedDate(maxDate)
												+ ")"
												: ""),
								ChartType.DOWNSTREAM_GRAPH);
				break;
			default:
				chart = ChartUtils
						.generateHighChart(
								records,
								"Porcentaje de Utilización de Ancho de Banda en "
										+ requiredInstallation.getName()
										+ ((requiredISP == null) ? "" : " ["
												+ requiredISP.getName() + "]"),
								"Gráfico General para "
										+ reqProfile.getNickname()
										+ ((minDate != null && maxDate != null) ? " ("
												+ getFormattedDate(minDate)
												+ " - "
												+ getFormattedDate(maxDate)
												+ ")"
												: ""), ChartType.GENERAL_GRAPH);
				break;
			}
			mav.addObject("javaChart", chart);
		}
		mav.addObject("minDate", getFormattedDate(minDate));
		mav.addObject("maxDate", getFormattedDate(maxDate));
		mav.addObject("currentGraphType", graphtype.getTranslationKey());
		mav.addObject("currentInstallation", requiredInstallation);
		mav.addObject("noRecords", noRecords);
		mav.addObject("requiredISP", requiredISP);
		mav.addObject("user", reqProfile);
		mav.addObject("loggedUser", me);
		return mav;
	}

	private User getSessionUser(HttpSession session) {
		Integer userId = (Integer) session.getAttribute("userId");
		return (userId == null) ? null : userRepo.get(userId);
	}

	class ValueComparator implements Comparator<Installation> {

		Map<Installation, List<ISP>> base;

		public ValueComparator(Map<Installation, List<ISP>> base) {
			this.base = base;
		}

		@Override
		public int compare(Installation o1, Installation o2) {
			return o1.getName().compareTo(o2.getName());
		}

	}

	public static String getFormattedDate(DateTime date) {

		if (date != null)
			return date.getDayOfMonth() + "/" + date.getMonthOfYear() + "/"
					+ date.getYear();

		return null;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView changeCongestionStatus(HttpSession session,
			@RequestParam(value = "id", required = true) Record r,
			@RequestParam(value = "type", required = true) String type) {

		ModelAndView mav = new ModelAndView();
		User me = getSessionUser(session);

		if (me == null) {
			mav.setView(ControllerUtil.redirectView("/login/login"));
			return mav;
		}

		if (me.getType().equals(UserType.ADMIN)) {
			mav.setView(ControllerUtil.redirectView("/user/adminpanel"));
		} else {
			mav.setView(ControllerUtil.redirectView("/user/dashboard"));
		}

		if (!r.getUser().equals(me)) {
			mav.addObject("errorDescription",
					"No tiene permisos borrar un record que no es suyo.");
			mav.setViewName("error");
			return mav;
		}

		r.changeCongestionStatus(type);
		mav.setView(ControllerUtil.redirectView("/user/dashboard?nickname="
				+ me.getNickname() + "&graphtype=GENERAL_GRAPH"));
		return mav;

	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView userreport(
			HttpSession session,
			@RequestParam(value = "nickname", defaultValue = "") String nickname,
			@RequestParam(value = "graphtype", defaultValue = "GENERAL_GRAPH") ChartType graphtype,
			@RequestParam(value = "ins", required = false) Installation requiredInstallation,
			@RequestParam(value = "isp", required = false) ISP requiredISP,
			@RequestParam(value = "minDate", required = false) DateTime miniDate,
			@RequestParam(value = "maxDate", required = false) DateTime maxiDate,
			@RequestParam(value = "test", required = false) String test) {

		// TODO
		// poner gráfico de usuario mensual
		// hacer tablita de medias
		ModelAndView mav = new ModelAndView();
		
		User reqProfile = userRepo.get(nickname);
		
		List<ISP> isps = recordRepo.getISPsForUser(reqProfile);

		List<String> ispNames = new ArrayList<String>();

		// TODO
		// Nowadays just shows the data from last month
		DateTime maxDate = new DateTime();
		DateTime minDate = maxDate.minusDays(30);
		List<Double> medians = new ArrayList<Double>();
		List<List<Double>> medianList = new ArrayList<List<Double>>();

		for (ISP isp : isps) {
			int id = isp.getId();
			String name = isp.getName();
			List<Record> records = (List<Record>) recordRepo.getAllForIsp2(id,
					minDate, maxDate);
			medians = ChartUtils.generateMedians(records);
			ispNames.add(name);
			medianList.add(medians);
		}

		
		List<Installation> userInstallations = reqProfile.getInstallations();
		List<String> userInstallationsnames = new ArrayList<String>();
		List<HighChart> javaChart_list = new ArrayList<HighChart>();

		for (Installation install : userInstallations) {
			userInstallationsnames.add(install.getName());
			List<Record> records = (List<Record>) recordRepo.getAll(reqProfile,
					install, minDate, maxDate);

			HighChart chart = ChartUtils.generateHighChart(
					records,
					"Porcentaje de Utilización de Ancho de Banda en "
							+ install.getName()
							+ ((requiredISP == null) ? "" : " ["
									+ requiredISP.getName() + "]"),
					"Gráfico General para "
							+ reqProfile.getNickname()
							+ ((minDate != null && maxDate != null) ? " ("
									+ getFormattedDate(minDate) + " - "
									+ getFormattedDate(maxDate) + ")" : ""),
					ChartType.GENERAL_GRAPH);

		
			javaChart_list.add(chart);

		}

		mav.addObject("javaChart_list", javaChart_list);
		mav.addObject("userInstallations", userInstallationsnames);
		mav.addObject("ispNames", ispNames);
		mav.addObject("medianList", medianList);

		return mav;
	}

	@SuppressWarnings("unchecked")
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView ispcharts(
			HttpSession session,
			@RequestParam(value = "minDate", required = false) DateTime minDate,
			@RequestParam(value = "maxDate", required = false) DateTime maxDate,
			@RequestParam(value = "dayOfWeek", required = false) Integer dayOfWeek, 
			@RequestParam(value = "minHour", required = false) Integer minHour,
			@RequestParam(value = "maxHour", required = false) Integer maxHour) {

		System.out
				.println("--------------------------------------------------------------------------------------------------------------------------------");
		System.out.println("minDate: " + minDate);
		System.out.println("maxDate: " + maxDate);
		System.out.println("dayOfWeek: " + dayOfWeek);
		System.out.println("minHour: " + minHour);
		System.out.println("maxHour: " + maxHour);
		System.out
				.println("--------------------------------------------------------------------------------------------------------------------------------");

		ModelAndView mav = new ModelAndView();
		User me = getSessionUser(session);

		if (me == null) {
			mav.setView(ControllerUtil.redirectView("/login/login"));
			return mav;
		}
		if (!me.getType().equals(UserType.ADMIN)) {
			mav.addObject("errorDescription",
					"No tiene permisos para acceder aquí.");
			mav.setViewName("error");
			return mav;
		}

		List<ISP> isps = recordRepo.getISPs();

		List<IspHistogramDisplayer> disp_list = new ArrayList<IspHistogramDisplayer>();
		List<IspBoxplotDisplayer> boxplot_list = new ArrayList<IspBoxplotDisplayer>();

		// TODO
		// Nowadays just shows the data from last month
		if (minDate == null && maxDate == null) {
			maxDate = new DateTime();
			minDate = maxDate.minusDays(30);
		}

		
		for (ISP isp : isps) {
			int id = isp.getId();
			String name = isp.getName();
			List<Record> records = (List<Record>) recordRepo.getAllForIsp2(id,
					minDate, maxDate);
			
			List<Record> recordsAux = new ArrayList<Record>();
			
			//FIltering by weekday
			if (dayOfWeek != null && dayOfWeek != 0  ) {//this filter is on  
				for( Record r: records){
					if ( r.getTimestamp().getDayOfWeek() == dayOfWeek ){
						recordsAux.add(r);
					}
				}
				records = recordsAux;
			}
			
			recordsAux = new ArrayList<Record>();
			
			//FIltering by hour
			if (minHour != null && maxHour != null  && minHour < maxHour  ) {//this filter is on  
				for( Record r: records){
					if ( r.getTimestamp().getHourOfDay() >=  minHour && r.getTimestamp().getHourOfDay( ) <= maxHour){
						recordsAux.add(r);
					}
				}
				records = recordsAux;
			}
			
						
			
//			System.out.println(minDate);
//			System.out.println(maxDate);
//			System.out.println("RECORDS: " + records);
			// histograms
			IspHistogramDisplayer disp = new IspHistogramDisplayer();
			disp.setIsp_id(id);
			disp.setIsp_name(name);
			disp.setCongestionUpChart(ChartUtils.generateHistogramCongestionUp(
					records, "histograma congestion up"));
			disp.setCongestionDownChart(ChartUtils
					.generateHistogramCongestionDown(records,
							"histograma congestion down"));
			disp.setUtilizacionUpChart(ChartUtils
					.generateHistogramUtilizacionUp(records,
							"histograma utilizacion up"));
			disp.setUtilizacionDownChart(ChartUtils
					.generateHistogramUtilizacionDown(records,
							"histograma utilizacion down"));
			disp_list.add(disp);

			// boxplots
			IspBoxplotDisplayer boxplot = new IspBoxplotDisplayer();
			boxplot.setIsp_id((id));
			boxplot.setIsp_name(name);
			List<double[]> boxplotdata = new ArrayList<double[]>();
			boxplotdata = ChartUtils.generateBoxplot(records);
			if (!boxplotdata.isEmpty()) {
				boxplot.setCongestionUpChart(boxplotdata.get(0));
				boxplot.setCongestionDownChart(boxplotdata.get(1));
				boxplot.setUtilizacionUpChart(boxplotdata.get(2));
				boxplot.setUtilizacionDownChart(boxplotdata.get(3));
				boxplot.setOccurrences((int)boxplotdata.get(4)[0]);
			}
			boxplot_list.add(boxplot);
			System.out.println(boxplot);
		}

		mav.addObject("disp_list", disp_list);
		mav.addObject("boxplot_list", boxplot_list);
		if (minDate != null) {
			mav.addObject("minDate", minDate.toString("dd/MM/yyyy"));
		}
		if (maxDate != null) {
			mav.addObject("maxDate", maxDate.toString("dd/MM/yyyy"));
		}
		
		if (dayOfWeek != null ){
			mav.addObject("dayOfWeek", dayOfWeek);
		}

		if (minHour != null && maxHour != null){
			mav.addObject("minHour", minHour);
			mav.addObject("maxHour", maxHour);
		}
		
		
		return mav;

	}

	@RequestMapping(method = RequestMethod.GET)
	public void getcsv(HttpSession session, HttpServletResponse response) {

		ModelAndView mav = new ModelAndView();
		User me = getSessionUser(session);

		if (me == null) {
			// mav.setView(ControllerUtil.redirectView("/login/login"));
			return;
		}
		if (!me.getType().equals(UserType.ADMIN)) {
			// mav.addObject("errorDescription",
			// "No tiene permisos para acceder aquí.");
			// mav.setViewName("error");
			return;
		}

		List<? extends Record> records = recordRepo.getAll();

		Writer writer = null;
		// String tmpFilename = "tmp/records.csv";
		File tmpFile = null;
		try {
			tmpFile = File.createTempFile("records", "csv");
			writer = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(tmpFile), "utf-8"));
			for (Record r : records) {
				writer.write(r.toCSV() + "\n");
			}
		} catch (IOException ex) {
			System.out.println("Error writing csv file");
		} finally {
			try {
				writer.close();
			} catch (Exception ex) {
			}
		}
		if (tmpFile != null) {
			try {
				response.setContentType("text/csv");
				DateTime today = new org.joda.time.DateTime();
				response.setHeader(
						"Content-Disposition",
						"attachment; filename=\"records_"
								+ today.toString("MMM") + "_" + today.getYear()
								+ ".csv\"");
				// get your file as InputStream
				InputStream is = new FileInputStream(tmpFile);
				// copy it to response's OutputStream
				IOUtils.copy(is, response.getOutputStream());
				response.flushBuffer();
			} catch (IOException ex) {
				throw new RuntimeException(
						"IOError writing file to output stream: "
								+ tmpFile.getName());
			}
		} else {
			System.out.println("Error while generating CSV file");
		}

	}
}
