module SideBarHelper
  def side_bar_items(ru)
    result = []
    result << {
      :name => 'Администрирование',
      :icon => 'users',
      :children => [
      {:name => 'Пользователи',
       :controller => :users, :action => :index,
       :icon => 'users',
       :class => 'long'},
      {:name => 'Добавление',
       :controller => :users, :action => :new,
       :icon => 'user-plus'},
      {:name => 'Роли',
       :controller => :roles, :action => :index,
       :icon => 'align-center',
       :class => 'long'},
    ]} if @current_role_user.try(:is_admin?)
    result << {
      :name => 'Расписание поездов',
      :icon => 'table',
      :children => [
      {:name => 'Станции',
       :controller => :stations, :action => :index,
       :icon => 'road'},
      {:name => 'Маршруты',
       :controller => :routes, :action => :index,
       :icon => 'train',
       :class => 'long'}
    ]} 
    result
  end
  
  def is_open?(ctr, act)
    case ctr.to_s
    when 'users', 'roles', 'routes', 'stations'
      ctr.to_s == controller_name.to_s  
    else
      false
    end
  end
end
