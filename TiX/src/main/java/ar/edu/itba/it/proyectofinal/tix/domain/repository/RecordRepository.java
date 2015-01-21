package ar.edu.itba.it.proyectofinal.tix.domain.repository;


import java.util.List;

import org.joda.time.DateTime;

import ar.edu.itba.it.proyectofinal.tix.domain.model.ISP;
import ar.edu.itba.it.proyectofinal.tix.domain.model.Installation;
import ar.edu.itba.it.proyectofinal.tix.domain.model.Record;
import ar.edu.itba.it.proyectofinal.tix.domain.model.User;


public interface RecordRepository {
	
	public void add(Record record);
	
	public List<? extends Record> getAll();
	
	public List<? extends Record> getAll(User user, Installation installation, DateTime minDate, DateTime maxDate);
	
	public List<? extends Record> getAllForISP(User user, Installation installation, ISP isp, DateTime minDate, DateTime maxDate);
	
	public List<ISP> getISPsForUser(User user);
	
	public List<? extends Record> getAllForIsp(ISP isp, DateTime minDate, DateTime maxDate);
	
	public List<? extends Record> getAllForIsp2(int isp, DateTime minDate, DateTime maxDate);

	public List<ISP> getISPsForInstallation(User user, Installation installation);
	
	public Record get(int id);

	public void removeAll(Installation installation);

	public List<ISP> getISPs();

}
