package ar.edu.itba.it.proyectofinal.tix.domain.service;

import ar.edu.itba.it.proyectofinal.tix.domain.model.User;
import ar.edu.itba.it.proyectofinal.tix.domain.util.Config;

public class MailBuilder {

	public static Mail buildUserRecoveryMail(User user, String cod) {
		Mail mail = new Mail(Config.getInstance().get("mailfrom"), user.getNickname()); // Nickname == email
		mail.setSubject("Recuperar clave");
		System.out.println("inside buildUserRecoveryMail!!!!");
		// TODO: esto tiene que ser leido de un tpt!
		String body = "<html><body>Para recuperar su contrase&ntilde;a siga el siguiente link "
			+ "<a href=\"http://tix.innova-red.net/bin/account/recoverpassword?cod="
			+ cod + "\" />tix.innova-red.net/bin/account/recoverpassword?cod="
			+ cod + "</body></html>";
		mail.setContents(body);
		return mail;
	}
}
