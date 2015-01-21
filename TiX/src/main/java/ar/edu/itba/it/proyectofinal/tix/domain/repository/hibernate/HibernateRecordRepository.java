package ar.edu.itba.it.proyectofinal.tix.domain.repository.hibernate;

import java.util.List;

import org.hibernate.SessionFactory;
import org.hibernate.classic.Session;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import ar.edu.itba.it.proyectofinal.tix.domain.model.ISP;
import ar.edu.itba.it.proyectofinal.tix.domain.model.Installation;
import ar.edu.itba.it.proyectofinal.tix.domain.model.Record;
import ar.edu.itba.it.proyectofinal.tix.domain.model.User;
import ar.edu.itba.it.proyectofinal.tix.domain.model.exception.RecordExistsException;
import ar.edu.itba.it.proyectofinal.tix.domain.repository.RecordRepository;

@Repository
public class HibernateRecordRepository extends AbstractHibernateRepo implements RecordRepository  {

	@Autowired
	public HibernateRecordRepository(SessionFactory sessionFactory) {
		super(sessionFactory);
	}

	@Override
	public void add(Record record) {
		if (exists("id", record.getId()) ) {
			throw new RecordExistsException();
		}
		save(record);
	}


	@Override
	public List<? extends Record> getAll() {
		return find("from Record");
	}


	public List<? extends Record> getAll(User user, Installation installation, DateTime minDate, DateTime maxDate) {
		if ( minDate != null && maxDate != null) {
			return find("from Record r where user_id = ? and installation = ? and r.timestamp >= ? and r.timestamp <= ? order by r.timestamp asc ", user.getId(), installation, minDate, maxDate);
		}
		return find("from Record r where user_id = ? and installation = ? order by r.timestamp asc ", user.getId(), installation);
	}

	public List<? extends Record> getAllForISP(User user, Installation installation, ISP isp, DateTime minDate, DateTime maxDate) {
		if ( minDate != null && maxDate != null) {
			return find("from Record r where user_id = ? and installation = ? and isp = ? and r.timestamp >= ? and r.timestamp <= ? order by r.timestamp asc", user.getId(), installation, isp, minDate, maxDate);
		}
		return find("from Record r where user_id = ? and installation = ? and isp = ? order by r.timestamp asc ", user.getId(), installation, isp);
	}

	public List<? extends Record> getAllForIsp2(int isp, DateTime minDate, DateTime maxDate /*, String  day, Integer minHour, Integer maxHour */){
		if ( minDate != null && maxDate != null) {
			return find("from Record r where isp_id = ? and r.timestamp >= ? and r.timestamp <= ? order by r.timestamp asc", isp, minDate, maxDate);
		}
		System.out.println("ISP: " +  isp);
	    return find("from Record r where isp_id = ? order by r.timestamp asc ", isp);
	}

	public List<ISP> getISPs(){
		return find("from ISP ");
	}
	
	public List<ISP> getISPsForUser(User user){
		Session session = getSession();
		return session.createQuery("select distinct isp as i from Record r where user_id = " + user.getId()).list();
	}

	public List<ISP> getISPsForInstallation(User user, Installation installation) {
		Session session = getSession();
		return session.createQuery("select distinct isp as i from Record r where user_id = " + user.getId() + "and installation_id = " +  installation.getId()).list();
//		return find("ISP i from Record r where user_id = ? and installation = ? and order by i.name desc ", user.getId(), installation);

	}


	@Override
	public Record get(int id) {
		return get(Record.class, id);
	}

	private boolean exists(String attr, Object id) {
		return !find("from Record where " + attr + " = ?", id).isEmpty();
	}

	@Override
	public void removeAll(Installation installation) {
		Session session = getSession();
		String hql = "delete from Record r where r.installation = ?";
		session.createQuery(hql).setEntity(0, installation).executeUpdate();
	}

	@Override
	public List<? extends Record> getAllForIsp(ISP isp, DateTime minDate,
			DateTime maxDate) {
		// TODO Auto-generated method stub
		return null;
	}

}
