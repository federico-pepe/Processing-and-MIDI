/*
 * Federico Pepe
 * blog.federicopepe.com
 * 09.09.2020
*/
import javax.sound.midi.*;
import themidibus.*;

MidiBus midi;         // this is or MIDI bus object

boolean play = false;

ArrayList<Reference> references = new ArrayList<Reference>();

void setup() {
  // MIDIBUS
  // MidiBus.list(); 
  midi = new MidiBus(this, 0, "Bus 1");
  size(500, 500);
  background(0);
  stroke(255);
  //
  references.add(new Reference((width - 100) / 4));
  references.add(new Reference((width - 100) / 4 * 2));
  references.add(new Reference((width - 100) / 4 * 3));
  references.add(new Reference((width - 100) / 4 * 4));
}

void draw() {
  background(0);
  for (int i = 0; i < references.size(); i++) {
    Reference part = references.get(i);
    part.display();
  }
  if (play) {
    Reference flash = references.get(beat - 1);
    flash.flash();
  }
}

void midiMessage(MidiMessage message) {
  // CONSTANTS
  String[] NOTE_NAMES = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"};
  int NOTE_ON = 0x90;
  int NOTE_OFF = 0x80;
  ShortMessage sm;
  // Send MIDI STATUS to the midiClock Function
  midiClock(message.getStatus());
  /* MIDI Commands:
   * Docs: http://docs.oracle.com/javase/7/docs/api/javax/sound/midi/ShortMessage.html#ShortMessage()
   * Eg. 144 = NOTE_ON; 128 = NOTE_OFF
   * Data1, the data in this field varies and depends on Message Type.
   * Eg. could be the Note number or the CC Number
   * Data2, the data in this field varies and depends on Message Type
   * Eg. Velocity, Pressure, or Data
   */
  sm = (ShortMessage) message;
  //println(message.getStatus());
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
//
// INSPIRED BY
// https://github.com/luiscript/NSYNC/blob/master/Processing/Processing_MIDI_clock/Processing_MIDI_clock.pde
// * * * * * * * * * * * * * *
int timing = 0;
int bar = 1;
int beat = 1;
int division = 1;

void midiClock(int midiStatus) {
  // MIDI STATUS MESSAGES:
  // START: Status byte for Start message (0xFA, or 250).
  // STOP: Status byte for Stop message (0xFC, or 252).
  // CLOCK: Status byte for Timing Clock messagem (0xF8, or 248).
  int START = 0xFA;
  int STOP  = 0xFC;
  int CLOCK = 0xF8;
  
  if (midiStatus == START) {
    play = true;
  } else if (midiStatus == STOP) {
    play = false;
    midiReset();
  } else if (midiStatus == CLOCK) {
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
// * * * * * * * * * * * * * * 
// MIDI RESET 
// Call this function everytime you need to reset MIDI
// by default it's called when the MIDI Clock receive a STOP.
// * * * * * * * * * * * * * *
void midiReset() {
  timing = 0;
  bar = 1;
  beat = 1;
  division = 1;
}
