class Energy {
  Neuron source;
  float MIN_ENERGY = 0.0;
  float MAX_ENERGY = 1.0;
  float fire_energy = 0.3; // the amount that depletes on firing 0.125
  float max_replenish_energy = 0.08;
  float min_replenish_energy = 0.02;
  float replenish_energy = 0.08; // the amount the energy pool replenishes
  float regeneration_time = 150; // time needed for energy to regenerate
  float available_energy;
  float last_refilled;
  float current_time;
  float last_updated_replenish_energy;
  float replenish_energy_update_period = 100;
  float replenish_energy_amplitude = 0.01;
  float replenish_energy_sign = -1;
  
  
  Energy(Neuron source_neuron) {
    source = source_neuron;
    available_energy = MAX_ENERGY;
    last_refilled = 0;
    last_updated_replenish_energy = 0;
  }
  
  float get_current_replenish_energy() {
    return replenish_energy;
  }
  
  boolean has_energy() {
    if (available_energy >= fire_energy) {
      return true;
    } else {
      return false;
    }
  }
  
  void deplete() {
    available_energy = available_energy - fire_energy;
    if (available_energy < MIN_ENERGY) {
      available_energy = MIN_ENERGY;
    }
  }
  
  void replenish() {
    if (current_time > (last_refilled + regeneration_time)) {
      //replenish_energy = random(min_replenish_energy, max_replenish_energy);
      available_energy = available_energy + replenish_energy;
      if (available_energy > MAX_ENERGY) {
        available_energy = MAX_ENERGY;
      }
      last_refilled = current_time;
    }
  }
  
  void update_replenish_energy() {
    if (current_time > (last_updated_replenish_energy + replenish_energy_update_period)) {
      replenish_energy = replenish_energy + (replenish_energy_sign * replenish_energy_amplitude);
      if (replenish_energy >= max_replenish_energy) {
        replenish_energy = max_replenish_energy;
        replenish_energy_sign = -1;
      } else if (replenish_energy <= min_replenish_energy) {
        replenish_energy = min_replenish_energy;
        replenish_energy_sign = 1;
      }
      last_updated_replenish_energy = current_time;
    }
  }
  
  void update(float time) {
    current_time = time;
    replenish();
    update_replenish_energy();
  }
}
