import peasy.*;

// create a small world graph algorithm

PeasyCam cam;
ArrayList<Neuron> globe;
float weight = 0.4;
float random_array[];
float time = 0;
float time_increment = 8.0;
float maxDistance;
float minDistance;
float num_inhibitory_prob_threhsold = 0.2;
float distance_length_connection_prob = 0.0; // previously 0.65
ArrayList<Integer> num_spikes_list = new ArrayList<Integer>();
ArrayList<Float> total_energy_list = new ArrayList<Float>();

void setup() {
  size(900, 900, P3D); 
  frameRate(40);
  cam = new PeasyCam(this, 2000);
  cam.rotateX(90);
  float r = 700;
  int total = 15; // 15
  globe = create_sphere(r, total);
  find_min_max_distance();
  create_connections(globe);
}

ArrayList<Neuron> create_sphere(float r, int total){
  int count = 0;
  randomSeed(1); // change this? 
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
      if (r_number <= num_inhibitory_prob_threhsold) {
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

void find_min_max_distance() {
  minDistance = Float.POSITIVE_INFINITY;
  maxDistance = Float.NEGATIVE_INFINITY;
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
}

void create_connections(ArrayList<Neuron> globe) {
  int total = globe.size();
  float max_dist = Float.NEGATIVE_INFINITY;
  float min_dist = Float.POSITIVE_INFINITY;
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
      if (dist < min_dist) {
        min_dist = dist;
      } else if (dist > max_dist) {
        max_dist = dist;
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
  println(max_dist);
  println(min_dist);
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

void draw() {
  time = time + time_increment;
  background(0);
  lights();
  draw_sphere(globe);
  draw_connections(globe);
  int num_spikes = 0;
  
  for (int i = 0; i < globe.size(); i++) {
    Neuron current_neuron =  globe.get(i);
    
    current_neuron.update(time);
    ArrayList<PVector> current_neuron_spike_locations = current_neuron.spike_locations;
    boolean is_inhibitory = false;
    if (current_neuron.is_inhibitory()) {
      is_inhibitory = true;
    }
    draw_spike_locations(current_neuron_spike_locations, is_inhibitory);
    
    ArrayList<Signal> current_neuron_output_signals = current_neuron.get_output_signals();
    for (int j = 0; j < current_neuron_output_signals.size(); j++) {
      Signal current_signal = current_neuron_output_signals.get(j);
      if (current_signal.is_spiking()) {
        num_spikes = num_spikes + 1;
      }
    }
  }
  num_spikes_list.add(num_spikes);
}

void mousePressed() {
  //println(num_spikes_list);
}
