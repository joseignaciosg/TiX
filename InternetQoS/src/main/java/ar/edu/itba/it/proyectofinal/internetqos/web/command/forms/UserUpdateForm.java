package ar.edu.itba.it.proyectofinal.internetqos.web.command.forms;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.validation.Errors;

import ar.edu.itba.it.proyectofinal.internetqos.domain.model.InvalidParametersException;
import ar.edu.itba.it.proyectofinal.internetqos.domain.model.User;
import ar.edu.itba.it.proyectofinal.internetqos.domain.model.UserBuilder;
import ar.edu.itba.it.proyectofinal.internetqos.domain.model.UserValidator;
import ar.edu.itba.it.proyectofinal.internetqos.domain.repository.UserRepository;
import ar.edu.itba.it.proyectofinal.internetqos.domain.util.AppError;
import ar.edu.itba.it.proyectofinal.internetqos.domain.util.ErrorUtil;

public class UserUpdateForm {

	@Email
	private String nickname;
	
	private String password1;


	public UserUpdateForm() {
	}

	public UserUpdateForm(User user) {
		setNickname(user.getNickname());
	}
	
	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	
	public String getPassword1() {
		return password1;
	}

	public void setPassword1(String password1) {
		this.password1 = password1;
	}

	public void clearPasswords() {
		setPassword1(null);
	}

	public User build(Errors errors, UserRepository userRepo) {
		User user = null;
		try {
			user = new User(nickname, password1);
		} catch (InvalidParametersException e) {
			ErrorUtil.rejectAll(errors, e.getErrors());
		}
		if (userRepo.existsNickname(nickname)) {
			errors.reject("nicknameExists");
		}
		return errors.hasErrors() ? null : user;
	}

	public void update(Errors errors, UserRepository userRepo, User user) {
		boolean passworchMatches = user.getPassword().equals(password1);
		if (!passworchMatches) {
			errors.reject(AppError.INCORRECT_PASSWORD.translationKey);
		}
		UserValidator userValidator = new UserValidator();
		if (!userValidator.emailValid(nickname)) {
			errors.reject(AppError.NICKNAME.translationKey);
		}
		if (passworchMatches && !userValidator.passwordValid(password1)) {
			errors.reject(AppError.INVALID_PASSWORD.translationKey);
		}
		if (!errors.hasErrors()) {
			UserBuilder.build(user, nickname, user.getPassword());
		}
	}
}
