import peasy.*;

PeasyCam cam;
ArrayList<Neuron> globe;
float weight = 0.4;
float time = 0;
float time_increment = 8.0;
float num_inhibitory_prob_threshold = 0.2;
float distance_length_connection_prob = 0.0; // previously 0.65
ArrayList<Integer> num_spikes_list = new ArrayList<Integer>();

void setup() {
  size(900, 900, P3D); 
  frameRate(40);
  cam = new PeasyCam(this, 2000);
  cam.rotateX(90);
  float r = 700;
  int total = 15;
  globe = create_sphere(r, total, num_inhibitory_prob_threshold = 0.2);
  create_connections(globe, distance_length_connection_prob);
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
