ArrayList<Neuron> create_sphere(float r, int total, float num_inhibitory_prob_threshold){
  int count = 0;
  //randomSeed(1);
  ArrayList<Neuron> globe = new ArrayList<Neuron>();
  for (int i = 0; i < total; i++) {
    float lat = map(i, 0, total, 0, PI);
    for (int j = 0; j < total; j++) {
      float lon = map(j, 0, total, 0, TWO_PI);
      float x = r * sin(lat) * cos(lon);
      float y = r * sin(lat) * sin(lon);
      float z = r * cos(lat);
      Neuron current_neuron = new Neuron(x, y, z);
      if (globe.contains(current_neuron)) {
        continue;
      }
      float r_number = random(0.0, 1.0);
      if (r_number <= num_inhibitory_prob_threshold) {
        current_neuron.set_as_inhibitory();
      }
      globe.add(current_neuron);
      count = count + 1;
     }
   }
  return globe;
}

void draw_sphere(ArrayList<Neuron> globe) {
  strokeWeight(15);
  int total = globe.size();
  stroke(227, 104, 104);
  for (int i = 0; i < total; i++) {
    Neuron n = globe.get(i);
    PVector v = n.get_location();
    if (n.is_inhibitory()) {
      stroke(227, 104, 104);
    }
    else {
      stroke(82, 179, 235);
    }
    point(v.x, v.y, v.z);
  }
}

float[] find_min_max_distance() {
  float[] distances = new float[2];
  float minDistance = Float.POSITIVE_INFINITY;
  float maxDistance = Float.NEGATIVE_INFINITY;
  int total = globe.size();
  for (int i = 0; i < total; i++) {
    Neuron n1 = globe.get(i);
    PVector v1 = n1.get_location();
    for (int j = 0; j < total; j++) {
      Neuron n2 = globe.get(j);
      PVector v2 = n2.get_location();
      float dist = v1.dist(v2);
      if (dist < 1.0) {
        continue;
      }
      if (dist < minDistance) {
        minDistance = dist;
      }
      if (dist > maxDistance) {
        maxDistance = dist;
      }
    }
  }
  distances[0] = minDistance;
  distances[1] = maxDistance;
  return distances;
}

void create_connections(ArrayList<Neuron> globe, float distance_length_connection_prob) {
  int total = globe.size();
  
  float[] min_max_distances = find_min_max_distance();
  float minDistance = min_max_distances[0];
  float maxDistance = min_max_distances[1];
  
  for (int i = 0; i < total; i++) {
    Neuron n1 = globe.get(i);
    PVector v1 = n1.get_location();
    for (int j = 0; j < total; j++) {
      Neuron n2 = globe.get(j);
      PVector v2 = n2.get_location();
      float dist = v1.dist(v2);
      if (dist < 1.0) {
        continue;
      }
      if (dist > 400) {
        continue;
      }
      float connection_prob = map(dist, minDistance, maxDistance, 1.0, 0.0); //<>//
      if (connection_prob > distance_length_connection_prob) {
        if (n1.is_inhibitory()) {
          n1.connect_to(n2, -weight);
        } else {
          n1.connect_to(n2, weight);
        }
      }
    }
  }
}

void draw_connections(ArrayList<Neuron> globe) {
  strokeWeight(0.8);
  stroke(149, 156, 153);
  for (int i = 0; i < globe.size(); i++) {
    Neuron current_neuron = globe.get(i);
    ArrayList<Signal> current_output_signals = current_neuron.get_output_signals();
    int output_signals_size = current_output_signals.size();
    for (int j = 0; j < output_signals_size; j++) {
      Signal current_output_signal = current_output_signals.get(j);
      PVector v1 = current_output_signal.get_source_location();
      PVector v2 = current_output_signal.get_target_location();
      line(v1.x, v1.y, v1.z, v2.x, v2.y, v2.z);
    }
  }
}

void draw_spike_locations(ArrayList<PVector> spike_locations, boolean is_inhibitory) {
  int total = spike_locations.size();
    if (is_inhibitory) {
      stroke(227, 104, 104);
    }
    else {
      stroke(82, 179, 235);
    }
  strokeWeight(7);
  for (int i = 0; i < total; i++) {
    PVector v = spike_locations.get(i);
    point(v.x, v.y, v.z);
  }
}
