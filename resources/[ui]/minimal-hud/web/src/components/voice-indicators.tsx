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

  // Don't show anything if not talking
  if (!voiceData.isTalking) {
    return null;
  }

  return (
    <div className="fixed bottom-5 right-5 z-50 font-inter">
      {/* Animated Voice Bars */}
      <div className="flex items-end justify-center gap-0.5 h-8 w-16">
        {[0, 1, 2, 3, 4, 5, 6].map((i) => (
          <div
            key={i}
            className={`w-1.5 rounded-sm transition-all duration-300 ${
              voiceData.talkingOnRadio
                ? "bg-blue-400/80 animate-voice-wave-radio"
                : "bg-yellow-400/80 animate-voice-wave-yellow"
            }`}
            style={{
              animationDelay: `${i * 0.1}s`,
            }}
          />
        ))}
      </div>
    </div>
  );
}