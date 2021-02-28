defmodule PasswordCalculator.DatabaseBackuper do
  @mix_env Application.get_env(:password_calculator, :mix_env)
  @project_root_dir Application.get_env(:password_calculator, :project_root_dir)
  def backup() do
  end

  def dump do
    @project_root_dir
    |> Path.join("script/dump_database.sh")
    |> System.cmd([Atom.to_string(@mix_env)])
    |> case do
      {dump_file_name, 0} -> {:ok, dump_file_name}
      {_, 1} -> {:error, :failed_dumping}
    end
  end

  defp upload_dump_file(dump_file_name) do
  end
end
