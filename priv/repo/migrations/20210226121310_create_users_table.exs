defmodule PasswordCalculator.Repo.Migrations.CreateUsersTable do
  use Ecto.Migration

  def up do
    execute("""
      CREATE TABLE public.users (
        id uuid NOT NULL,
        email varchar(256) NOT NULL,
        password varchar(256) NOT NULL,
        name varchar(128) NOT NULL,
        phone_number varchar(32) NOT NULL,
        master_key varchar(256) NOT NULL,
        inserted_at timestamp with time zone NOT NULL,
        updated_at timestamp with time zone NOT NULL,

        CONSTRAINT pk_users PRIMARY KEY (id),
        CONSTRAINT uq_email UNIQUE (email)
      );
    """)
  end

  def down do
    execute("DROP TABLE public.users;")
  end
end
