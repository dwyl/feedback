alias Feedback.{Repo, User}

case Repo.get_by(User, first_name: "Admin") do
  nil ->
    Repo.insert! %User{
      first_name: "Admin",
      last_name: "Account",
      email: System.get_env("ADMIN_EMAIL"),
      password: System.get_env("ADMIN_PASSWORD"),
      password_hash: Comeonin.Bcrypt.hashpwsalt(System.get_env("ADMIN_PASSWORD"))
    }
  _user -> IO.puts "Admin already in database"
end
