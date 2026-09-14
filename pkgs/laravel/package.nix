{
  lib,
  fetchFromGitHub,
  makeWrapper,
  php,
  nodejs,
  pnpm,
}:
php.buildComposerProject2 (finalAttrs: {
  pname = "laravel";
  version = "5.32.0";

  src = fetchFromGitHub {
    owner = "laravel";
    repo = "installer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qHZP9zkZ+uvJy/BEkr1A+gWm6DKgBnfCOqKQ7Kxq2j8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  composerLock = ./composer.lock;
  vendorHash = "sha256-aQ4+eIxIp484Bkv67cO9h2Hr8kgLsNpWCissM29MQg8=";

  # Adding php, composer, node and pnpm to path
  postInstall = ''
    wrapProgram $out/bin/laravel \
      --suffix PATH : ${
        lib.makeBinPath [
          php
          php.packages.composer
          nodejs
          pnpm
        ]
      }
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Laravel application installer";
    homepage = "https://laravel.com/docs#creating-a-laravel-project";
    changelog = "https://github.com/laravel/installer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "laravel";
  };
})
