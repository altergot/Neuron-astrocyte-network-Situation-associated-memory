
# Neuro-astro network model

Here we propose a computational model of situation-associated memory in spiking neuron-astrocyte network

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- MATLAB ≥R2018b
- Statistics Toolbox
- Image Processing Toolbox
- The minimum required amount of RAM is 16 GB

### Installing

Clone repo:
```
git clone https://github.com/altergot/Neuron-astrocyte-network-Situation-associated-memory.git
```

### Running the experiment

To run the default experiment execute `src/main.m`

#### SNN pre-training:

*SNN: spiking neural network*
Default experiment consists of pre-training for 20 binary images of letters and numbers.
We pre-trained synaptic connections only in the spiking neuronal network consists of pyramidal neurons and interneurons without taking into account the influence of astrocytes. 
During pre-training each of patterns was presented to the neuronal network 10 times in random order.

#### Situation-associated learning in SNAN:

*SNAN: spiking neuron-astrocyte network*
After the SNN pre-training, we turn on the bidirectional interaction between pyramidal neurons layer and astrocytic layer.
To let the astrocytic network to generate the first calcium pattern we apply to SNAN the initial pool of patterns which consists of randomly selected 7 patterns from the general data set used in the SNN pre-training.
After some break(approximately 650 ms) necessary for the formation of calcium  impulses  in  pattern-associated  astrocytes,  we start ongoing training-testing process of the SNAN in real time. 
Every test cycle start with training of the SNAN on the one new pattern, which was absent in the initial pool and was randomly chosen from the general data set.
After that, we test the storage in memory of all patterns from the initial pool.  We present the SNAN the 7 test patterns which match the patterns from the initial pool.
In the next cycle one pattern from the initial pool is replaced by new pattern which has been learned in the previous cycle.
This procedure can be performed indefinitely, allowing the system to work with all templates from the common dataset in a situation-specific manner. We limited ourselves to 10 cycles.


The simulation model time is 1.1 seconds in the SNN pre-training and 7.3 seconds in Situation-associated learning in SNAN. The time step is 0.0001 seconds.
The program run time for default parameters is around 3 hours.

![response](/results/Training_Testing_Protocol.png "Training and Testing Protocol")

### Results

The following results are presented at the end of the simulation:

1. Test patterns and their corresponding neuron binarized frequencies

![response](/results/Test.png "Test")

2. The average correlation of recalled pattern with ideal item

Average correlation = 0.9224

### Parameters

File model_parameters.m consists of multiple parameter sections described in the paper:
- Timeline
- Experiment
- Applied pattern current
- Poisson noise
- Runge-Kutta steps
- Network size
- Initial conditions
- Neuron mode
- Synaptic connections
- Astrosyte model
- Memory performance

## Authors

* **Yulia Tsybina** - *Implementation* - [altergot](https://github.com/altergot)
* **Mikhail Krivonosov** - *Implementation* - [mike_live](https://github.com/mike_live)
* **Susan Gordleeva** - *Biological model constructing*
* **Ivan Tyukin** - *Project vision*
* **Victor Kazantsev** - *Project vision*
* **Alexey Zaikin** - *Project vision*
* **Alexander Gorban** - *Project vision*


## Cite

Situation-associated memory in neuromorphic model of spiking neuron-astrocyte network
Susanna Gordleeva, Yuliya A. Tsybina, Mikhail I. Krivonosov, Ivan Y. Tyukin, Victor B. Kazantsev, Alexey A. Zaikin, Alexander N. Gorban

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
