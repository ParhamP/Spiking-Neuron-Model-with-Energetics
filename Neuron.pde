class Neuron {
  PVector location;
  ArrayList<Signal> output_signals = new ArrayList<Signal>();
  float V_R = -0.875; // resting membrane potential
  float V = V_R; // current membrane potential
  float V_THETA = 0.60; // firing threshold potential
  float TAU_V = 0.03; // decay parameter
  float REFRACTORY_PERIOD_DURATION = 10; // refactory period time in ms
  boolean in_refractory_period = false;
  float current_time;
  float refractory_time_start;
  ArrayList<PVector> spike_locations;
  boolean is_inhibitory = false;
  Energy energy_pool;
  
  Neuron() {
  }
  
  Neuron(float x, float y, float z) {
    set_location(x, y, z);
    energy_pool = new Energy(this);
  }
  
  void set_location(float x, float y, float z) {
    location = new PVector(x, y, z);
  }
  
  PVector get_location() {
    return location;
  }
  
  Signal get_output_signal(int index) {
    return output_signals.get(index);
  }
  
  void connect_to(Neuron output, float weight) {
    Signal output_signal = new Signal(this, output, weight);
    output_signals.add(output_signal);
  }
  
  ArrayList<Signal> get_output_signals() {
    return output_signals;
  }
  
  Energy get_energy_pool() {
    return energy_pool;
  }
  
   void set_as_inhibitory() {
    is_inhibitory = true;
  }
  
  boolean is_inhibitory() {
    if (is_inhibitory) {
      return true;
    } else {
      return false;
    }
  }
  
  void decay_membrane_potential() {
    if (in_refractory_period) {
      return;
    }
    float tau_v = random(0.01, 0.05);
    V = V + tau_v;
  }
  
  void reset_membrane_potential() {
    V = V_R;
  }
  
  void update_membrane_potential(float weight) {
    if (in_refractory_period) {
      return;
    }
    V = V + weight;
  }
  
  void enter_refractory_period() {
    in_refractory_period = true;
    refractory_time_start = current_time;
  }
  
  void update(float time) {
    current_time = time;
    energy_pool.update(time);
    spike_locations = new ArrayList<PVector>();
    if (current_time > (refractory_time_start + REFRACTORY_PERIOD_DURATION)) {
        in_refractory_period = false;
    }
    decay_membrane_potential();
    if (V > V_THETA && energy_pool.has_energy()) {
      spike();
    }
    for (int s_i = 0; s_i < output_signals.size(); s_i++) {
      Signal current_signal = output_signals.get(s_i);
      current_signal.update(current_time);
      if (current_signal.spike_initiated) {
        spike_locations.add(current_signal.spike_location);
      }
    }
  }
  
  void spike() {
    if (in_refractory_period) {
      return;
    }
    energy_pool.deplete();
    enter_refractory_period();
    for (int s_i = 0; s_i < output_signals.size(); s_i++) {
      Signal current_signal = output_signals.get(s_i);
      current_signal.initiate_spike();
    }
    reset_membrane_potential();
  }
  
  @Override
    public boolean equals(Object o) {
      if (o == this) {
        return true;
      }
      if (!(o instanceof Neuron)) {
            return false;
      }
      Neuron c = (Neuron) o;
      return this.get_location().equals(c.get_location());
    }
    
    @Override
    public String toString()
    {
         return get_location().toString();
    }
    
}
