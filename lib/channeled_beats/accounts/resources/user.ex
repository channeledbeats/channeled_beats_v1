defmodule ChanneledBeats.Accounts.User do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication]

  attributes do
    uuid_primary_key(:id)

    attribute(:email, :ci_string, allow_nil?: false)
    attribute(:hashed_password, :string, allow_nil?: false, sensitive?: true)
    attribute(:username, :ci_string, allow_nil?: false)
  end

  validations do
    validate string_length(:username, min: 2, max: 50)
  end

  actions do
    defaults [:read, :create, :update]
  end

  authentication do
    api(ChanneledBeats.Accounts)

    strategies do
      password :password do
        identity_field(:email)
        sign_in_tokens_enabled?(true)
        register_action_accept([:username])

        resettable do
          sender ChanneledBeats.Accounts.SendPasswordResetEmail
        end
      end
    end

    tokens do
      enabled?(true)
      token_resource(ChanneledBeats.Accounts.Token)
      signing_secret(ChanneledBeats.Accounts.Secrets)
    end
  end

  postgres do
    table("users")
    repo(ChanneledBeats.Repo)
  end

  identities do
    identity(:unique_email, [:email]) do
      eager_check_with ChanneledBeats.Accounts
    end
    identity(:unique_username, [:username]) do
      eager_check_with ChanneledBeats.Accounts end
  end
end
