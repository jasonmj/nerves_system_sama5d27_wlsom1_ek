defmodule NervesSystemSAMA5D27WLSOM1EK.MixProject do
  use Mix.Project

  @github_organization "amclain"
  @app :nerves_system_sama5d27_wlsom1_ek
  @version Path.join(__DIR__, "VERSION")
           |> File.read!()
           |> String.trim()

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.14",
      compilers: Mix.compilers() ++ [:nerves_package],
      nerves_package: nerves_package(),
      description: description(),
      package: package(),
      deps: deps(),
      aliases: [loadconfig: [&bootstrap/1]],
      docs: [extras: ["README.md"], main: "readme"]
    ]
  end

  def application do
    []
  end

  defp bootstrap(args) do
    set_target()
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  defp nerves_package do
    [
      type: :system,
      artifact_sites: [
        {:github_releases, "#{@github_organization}/#{@app}"}
      ],
      build_runner_opts: build_runner_opts(),
      platform: Nerves.System.BR,
      platform_config: [
        defconfig: "nerves_defconfig"
      ],
      checksum: package_files()
    ]
  end

  defp deps do
    [
      {:nerves, "~> 1.5.4 or >= 1.6.0", runtime: false},
      {:nerves_system_br, "1.21.4", runtime: false},
      {:nerves_toolchain_armv7_nerves_linux_gnueabihf, "~> 1.6.1", runtime: false},
      {:nerves_system_linter, "~> 0.4", runtime: false},
      {:ex_doc, "~> 0.29", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Nerves System - SAMA5D27 WLSOM1 EK Dev Kit
    """
  end

  defp package do
    [
      files: package_files(),
      licenses: ["Apache 2.0"],
      links: %{"Github" => "https://github.com/#{@github_organization}/#{@app}"}
    ]
  end

  defp package_files do
    [
      "fwup_include",
      "linux",
      "package",
      "rootfs_overlay",
      "uboot",
      "CHANGELOG.md",
      "Config.in",
      "external.mk",
      "fwup-revert.conf",
      "fwup.conf",
      "LICENSE",
      "mix.exs",
      "nerves_defconfig",
      "post-build.sh",
      "post-createfs.sh",
      "README.md",
      "VERSION"
    ]
  end

  defp build_runner_opts() do
    if primary_site = System.get_env("BR2_PRIMARY_SITE") do
      [make_args: ["BR2_PRIMARY_SITE=#{primary_site}"]]
    else
      []
    end
  end

  defp set_target() do
    if function_exported?(Mix, :target, 1) do
      apply(Mix, :target, [:target])
    else
      System.put_env("MIX_TARGET", "sama5d27_wlsom1_ek")
    end
  end
end
