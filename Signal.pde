class Signal{
  PVector location;
  Neuron source;
  Neuron target;
  float speed = 0.05;
  float weight;
  boolean spike_initiated;
  float last_jump_time;
  ArrayList<PVector> signal_path_locations;
  PVector spike_location;
  int spike_location_index;
  float current_time;
  float path_sampling_value = 10; // 10
  
  Signal(){
  }
  
  Signal(Neuron source_neuron, Neuron target_neuron, float neuron_weight) {
    source = source_neuron;
    target = target_neuron;
    weight = neuron_weight;
    set_location(source);
    spike_initiated = false;
    spike_location = source_neuron.get_location();
    signal_path_locations = create_signal_path_locations();
  }
  
  void set_weight(float neuron_weight) {
    weight = neuron_weight;
  }
  
  float get_weight() {
    return weight;
  }
  
  void set_location(float x, float y, float z) {
    location = new PVector(x, y, z);
  }
  
  
  PVector get_location() {
    return location;
  }
  
  PVector get_source_location() {
    return source.get_location();
  }
  
  PVector get_target_location() {
    return target.get_location();
  }
  
  void set_location(Neuron neuron) {
    PVector neuron_location = neuron.get_location();
    
    this.set_location(neuron_location.x, neuron_location.y, neuron_location.z);
  }
  
  void initiate_spike() {
    spike_initiated = true;
    last_jump_time = current_time;
    spike_location_index = 0;
  }
  
  
  ArrayList<PVector> create_signal_path_locations() {
    float s_length = signal_length();
    int num_bumps = floor(s_length/path_sampling_value);
    ArrayList<PVector> path_locations = new ArrayList<PVector>();
    float initial_lerp = 1.0/num_bumps;
    for (int i = 1; i < num_bumps - 1; i++) {
      float lerp_amount = map(i, 1, num_bumps - 1, initial_lerp, 1.0);
      PVector current_bump = PVector.lerp(source.get_location(), target.get_location(), lerp_amount);
      path_locations.add(current_bump);
    }
    path_locations.add(target.get_location());
    return path_locations;
  }
  
  
  float signal_length() {
    float dist;
    PVector source_location = source.get_location();
    PVector target_location = target.get_location();
    dist = source_location.dist(target_location);
    return dist;
  }
  
  
  void update(float time) {
    current_time = time;
    if (spike_initiated) {
      if (current_time > (last_jump_time + speed)) {
        spike_location_index = spike_location_index + 1;
        spike_location = signal_path_locations.get(spike_location_index);
        last_jump_time = current_time;
        //println(spike_location);
        if (spike_location.equals(target.get_location())) {
          target.update_membrane_potential(weight); //<>//
          spike_location = source.get_location();
          spike_initiated = false;
        }
      }
    }
  }
}
