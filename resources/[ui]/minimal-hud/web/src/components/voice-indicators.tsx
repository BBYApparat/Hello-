import { useNuiEvent } from "@/hooks/useNuiEvent";
import { useState } from "react";

interface VoiceData {
  isTalking: boolean;
  talkingOnRadio: boolean;
  onRadio: boolean;
  onPhone: boolean;
  voiceRange: number;
}

export default function VoiceIndicators() {
  const [voiceData, setVoiceData] = useState<VoiceData>({
    isTalking: false,
    talkingOnRadio: false,
    onRadio: false,
    onPhone: false,
    voiceRange: 2,
  });

  useNuiEvent("setPlayerState", (data: any) => {
    if (data) {
      setVoiceData({
        isTalking: data.isTalking || false,
        talkingOnRadio: data.talkingOnRadio || false,
        onRadio: data.onRadio || false,
        onPhone: data.onPhone || false,
        voiceRange: data.voiceRange || 2,
      });
    }
  });

  // Don't show anything if not talking and not on phone/radio
  if (!voiceData.isTalking && !voiceData.onPhone && !voiceData.onRadio) {
    return null;
  }

  return (
    <div className="fixed bottom-5 right-5 z-50 font-inter">
      {/* Phone/Radio Icons */}
      {(voiceData.onPhone || voiceData.onRadio) && (
        <div className="absolute -top-10 left-1/2 transform -translate-x-1/2 flex items-center justify-center">
          {voiceData.onPhone && (
            <div className="text-2xl text-green-400 animate-pulse">📞</div>
          )}
          {voiceData.onRadio && !voiceData.onPhone && (
            <div className="text-2xl text-blue-400 animate-pulse">📻</div>
          )}
        </div>
      )}

      {/* Voice Range Indicators */}
      {(voiceData.isTalking || voiceData.onRadio) && (
        <div className="absolute -top-4 left-1/2 transform -translate-x-1/2 flex gap-1">
          {[1, 2, 3].map((i) => (
            <div
              key={i}
              className={`w-2 h-1 rounded-sm transition-all duration-300 ${
                i <= voiceData.voiceRange
                  ? "bg-white/90 shadow-white/50 shadow-sm"
                  : "bg-white/30"
              }`}
            />
          ))}
        </div>
      )}

      {/* Animated Voice Bars */}
      {voiceData.isTalking && (
        <div className="flex items-end justify-center gap-0.5 h-8 w-16">
          {[0, 1, 2, 3, 4, 5, 6].map((i) => (
            <div
              key={i}
              className={`w-1.5 rounded-sm transition-all duration-300 ${
                voiceData.talkingOnRadio
                  ? "bg-blue-400/80 animate-voice-wave-radio"
                  : "bg-green-400/80 animate-voice-wave"
              }`}
              style={{
                animationDelay: `${i * 0.1}s`,
              }}
            />
          ))}
        </div>
      )}
    </div>
  );
}