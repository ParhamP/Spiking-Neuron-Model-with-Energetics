class Energy {
  Neuron source;
  float MIN_ENERGY = 0.0;
  float MAX_ENERGY = 1.0;
  float fire_energy = 0.227; // the amount that depletes on firing 0.125
  //float fire_energy = 0.0;
  float replenish_energy = 0.08; // the amount the energy pool replenishes
  float regeneration_time = 150; // time needed for energy to regenerate
  float available_energy;
  float last_refilled;
  
  Energy(Neuron source_neuron) {
    source = source_neuron;
    available_energy = MAX_ENERGY;
    last_refilled = 0;
  }
  
  boolean has_energy() {
    if (available_energy >= fire_energy) {
      return true;
    } else {
      //float s = random(0, 1);
      //println(s);
      return false;
    }
  }
  
  void deplete() {
    available_energy = available_energy - fire_energy;
    if (available_energy < MIN_ENERGY) {
      available_energy = MIN_ENERGY;
    }
  }
  
  void replenish(float current_time) {
    if (current_time > (last_refilled + regeneration_time)) {
      //println("replenished");
      available_energy = available_energy + replenish_energy;
      if (available_energy > MAX_ENERGY) {
        available_energy = MAX_ENERGY;
      }
      last_refilled = current_time;
    }
  }
}
