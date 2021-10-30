#include "SoundpipeDSPBase.h"
#include "ParameterRamper.h"

enum TriggerMixerParameter : AUParameterAddress {
    TriggerMixerParameterBalance,
};

class TriggerMixerDSP : public SoundpipeDSPBase {
private:
    ParameterRamper balanceRamp;

public:
    TriggerMixerDSP() {
        inputBufferLists.resize(2);
        parameters[TriggerMixerParameterBalance] = &balanceRamp;
    }

    void process(FrameRange range) override {
        for (int i : range) {

            float balance = balanceRamp.getAndStep();

            for (int channel = 0; channel < channelCount; ++channel) {
                outputSample(channel, i) =  balance > 0.5 ? input2Sample(channel, i) : inputSample(channel, i);
            }

        }
    }
};

AK_REGISTER_DSP(TriggerMixerDSP, "trmx")
AK_REGISTER_PARAMETER(TriggerMixerParameterBalance)
