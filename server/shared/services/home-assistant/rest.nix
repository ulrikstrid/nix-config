[
  # Pellet burner
  {
    scan_interval = 10;
    resource = "http://192.168.1.161/data.html";
    sensor = [
      {
        name = "Pellet Burner data";
        value_template = "{{ value_json.glow }}";
        json_attributes = [
          "mode"
          "glow"
          "ttop"
          "tbuttom"
          "feed"
          "xFan"
          "cFan"
          "tFlame"
          "tFlue"
          "draft"
          "amps"
          "tRoom"
          "tStop"
          "tStart"
          "nattFlagg"
          "mode2"
          "alarm1"
          "alarm2"
          "lang"
          "bmpT"
        ];
      }
    ];
  }
]
