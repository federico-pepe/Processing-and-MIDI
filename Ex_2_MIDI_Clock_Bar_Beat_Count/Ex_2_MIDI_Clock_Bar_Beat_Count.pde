import javax.sound.midi.*;
import themidibus.*;

MidiBus midi;         // this is or MIDI bus object

void setup() {
  // MIDIBUS
  MidiBus.list(); 
  midi = new MidiBus(this, 0, "Bus 1");
}

void draw() {
  println(bar + "." + beat + "." + division % 4);
}

void midiMessage(MidiMessage message) {
  // CONSTANTS
  String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  int NOTE_ON = 0x90;
  int NOTE_OFF = 0x80;
  ShortMessage sm;
  /* MIDI Commands:
   * Docs: http://docs.oracle.com/javase/7/docs/api/javax/sound/midi/ShortMessage.html#ShortMessage()
   * Eg. 144 = NOTE_ON; 128 = NOTE_OFF
   * Data1, the data in this field varies and depends on Message Type.
   * Eg. could be the Note number or the CC Number
   * Data2, the data in this field varies and depends on Message Type
   * Eg. Velocity, Pressure, or Data
   */
  sm = (ShortMessage) message;
  // DEBUGGING MIDI DATA
  // println("MIDI Channel: " + myShortMessage.getChannel());
  // println("MIDI Command : " + myShortMessage.getCommand());
  // println("Data1 : " + myShortMessage.getData1());
  // println("Data 2: " + myShortMessage.getData2());
  // println("Channel: " + sm.getChannel() + " ");
  if (sm.getCommand() == NOTE_ON) {
    int msg = sm.getData1();
    int oct = (msg / 12) - 2;
    int note = msg % 12;
    println("Channel: " + sm.getChannel() + " " + oct, NOTE_NAMES[note], msg);
  }
}

// * * * * * * * * * * * * * * 
// THIS IS THE MIDI CLOCK 
// This function will be called when raw MIDI data arrives
// INSPIRED BY
// https://github.com/luiscript/NSYNC/blob/master/Processing/Processing_MIDI_clock/Processing_MIDI_clock.pde
// * * * * * * * * * * * * * *
int timing = 0;
int bar = 1;
int beat = 1;
int division = 1;
void rawMidi(byte[] data) {  
  // MIDI CLOCK STOPS
  if (data[0] == (byte)0xFC) {
    // reset timing when clock stops to stay in sync for the next start
    timing = 0;
    bar = 1;
    beat = 1;
    division = 1;
  } else if (data[0] == (byte)0xF8) {
    // EVERY MIDI CLOCK PULSE THIS IS TRUE
    // Increase timing every pulse to get the total count
    // MIDI clock sends 24 ppqn (pulses per quarter note)
    timing++;
    if (timing % 6 == 0) {
      // 1/16th
      division++;
    }
    if (timing % 24 == 0) {
      // 1/4th note
      beat++;
    }
    if (timing % 96 == 0) {
      // 1 Bar
      bar++;
      beat = 1;
      division = 1;
    }
  }
}
