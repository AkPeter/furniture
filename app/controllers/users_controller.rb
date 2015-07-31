class UsersController < ApplicationController
  PasswordResurrectionKillDelay = 15.minutes

  def signin
    @user = User.new
  end

  def create
    password = SecureRandom.hex(8)[0..7] # ну так захотел слабоумный пидорис заказчик )
    admin = params[:email] == 'shadows.of.unevenness@gmail.com'
    @user = User.new(name: params[:name], email: params[:email].downcase, phone: params[:phone], password: password, admin: admin)
      if @user.save
        session[:uid] = @user.id
        UserMailer.new_bee(@user, password).deliver_now
        redirect_to personal_page_path, notice: 'Регистрация прошла успешно'
      else
        render :signin
      end
  end

  def update
    respond_to do |format|
      @user = current_user
      if @user.update(name: params[:name], phone: params[:phone], password: params[:password])
        flash[:notice] = 'Личные данные успешно изменены'
        format.html { redirect_to action: 'personal_page' }
        format.json { head :no_content }
      else
        flash[:notice] = 'Войдите на сайт'
        format.html { redirect_to signin_path }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def password_reset
    resurrection =  SecureRandom.hex(8)
    @user = User.find(params[:uid])
    if @user.update(resurrection: resurrection)
      UserMailer.password_reset(@user, resurrection).deliver_now
      # снаряжаем фоновую задачу правильным образом !
      kill_time = DateTime.now + UsersController::PasswordResurrectionKillDelay
      PasswordResurrectionKillJob.set(wait_until: kill_time).perform_later(@user.id)

      flash[:notice] = 'Инструкция для смены пароля была выслана на Ваш email'
      redirect_to signin_url
    else
      flash[:notice] = 'Вероятно проблемы со связью, попробуйте заново'
      redirect_to signin_url
    end
  end

  def personal_page
    if current_user
      @user = current_user
      render :template => 'users/personal_page'
    else
      redirect_to root_url, notice: 'Зарегистрируйтесь'
    end
  end
end