#include "SoundpipeDSPBase.h"
#include "ParameterRamper.h"

enum StormMixerParameter : AUParameterAddress {
    StormMixerParameterBalance,
    StormMixerParameterVolume,
};

class StormMixerDSP : public SoundpipeDSPBase {
private:
    ParameterRamper balanceRamp;
    ParameterRamper volumeRamp;

public:
    StormMixerDSP() {
        inputBufferLists.resize(2);
        parameters[StormMixerParameterBalance] = &balanceRamp;
        parameters[StormMixerParameterVolume] = &volumeRamp;
    }

    void process(FrameRange range) override {
        for (int i : range) {

            float balance = balanceRamp.getAndStep();
            float volume = volumeRamp.getAndStep();
            for (int channel = 0; channel < channelCount; ++channel) {
                float dry = inputSample(channel, i);
                float wet = input2Sample(channel, i);
                outputSample(channel, i) =  volume * ((1.0f - balance) * dry + balance * wet);
            }
        }
    }
};

AK_REGISTER_DSP(StormMixerDSP, "stmx")
AK_REGISTER_PARAMETER(StormMixerParameterBalance)
AK_REGISTER_PARAMETER(StormMixerParameterVolume)
