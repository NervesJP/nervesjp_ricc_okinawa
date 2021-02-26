defmodule NervesRiccOkinawa.MixProject do
  use Mix.Project

  @app :nerves_ricc_okinawa
  @version "0.2.0"
  @all_targets [:rpi0, :rpi3, :rpi4]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {NervesRiccOkinawa.Application, []},
      extra_applications: [:logger, :runtime_tools, :inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.7.0", runtime: false},
      {:shoehorn, "~> 0.7.0"},
      {:ring_logger, "~> 0.8.1"},
      {:toolshed, "~> 0.2.13"},
      {:circuits_gpio, "~> 0.4"},
      {:circuits_i2c, "~> 0.1"},
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.2"},
      {:timex, "~> 3.5"},
      {:phoenix_ricc_okinawa, path: "../phoenix_ricc_okinawa"},

      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.11.3", targets: @all_targets},
      {:nerves_pack, "~> 0.4.0", targets: @all_targets},

      # Dependencies for specific targets
      {:nerves_system_rpi0, "== 1.14.0", runtime: false, targets: :rpi0},
      {:nerves_system_rpi3, "== 1.14.0", runtime: false, targets: :rpi3},
      {:nerves_system_rpi4, "== 1.14.0", runtime: false, targets: :rpi4}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
