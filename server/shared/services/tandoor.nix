/* docker run -d \
    -v ./staticfiles:/opt/recipes/staticfiles \
    -v ./mediafiles:/opt/recipes/mediafiles \
    -p 80:8080 \
    -e SECRET_KEY=YOUR_SECRET_KEY \
    -e DB_ENGINE=django.db.backends.postgresql \
    -e POSTGRES_HOST=db_recipes \
    -e POSTGRES_PORT=5432 \
    -e POSTGRES_USER=djangodb \
    -e POSTGRES_PASSWORD=YOUR_POSTGRES_SECRET_KEY \
    -e POSTGRES_DB=djangodb \
    --name recipes_1 \
    vabene1111/recipes
*/
{
  virtualisation.oci-containers.containers."tandoor-web" = {
    image = "vabene1111/recipes";
    environment = {
      "SECRET_KEY" = "super_secret";
      "DB_ENGINE" = "django.db.backends.postgresql";
      "POSTGRES_HOST" = "192.168.1.101";
      "POSTGRES_PORT" = "5432";
      "POSTGRES_USER" = "tandoor";
      "POSTGRES_PASSWORD" = "YOUR_POSTGRES_SECRET_KEY";
      "POSTGRES_DB" = "tandoor";
    };
    ports = [ "5080:8080" ];
    volumes = [
      "/home/delegator/tandoor/staticfiles:/opt/recipes/staticfiles"
      "/home/delegator/tandoor/mediafiles:/opt/recipes/mediafiles"
    ];
    extraOptions = [
      #"--network=bridge"
      # "--dns 192.168.1.1"
    ];
  };

  networking.firewall.allowedTCPPorts = [ 5080 ];
}
