/*
 * Federico Pepe
 * blog.federicopepe.com
 * 09.09.2020
 */
import javax.sound.midi.*;
import themidibus.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import nice.palettes.*;

MidiBus midi;         // this is or MIDI bus object
ColorPalette palette;

boolean play = false;

ArrayList<Reference> references = new ArrayList<Reference>();
HashMap<String, Drum> drums = new HashMap<String, Drum>();

void setup() {
  // MIDIBUS
  // MidiBus.list(); 
  midi = new MidiBus(this, 0, "Bus 1");
  // Color Palette
  // Initialize it, passing a reference to the current PApplet 
  palette = new ColorPalette(this);
  palette.getPalette(5);
  // Ani Library
  Ani.init(this);
  /*** LET'S START ***/
  colorMode(HSB);
  size(500, 500);
  pixelDensity(2);
  background(palette.colors[0]);
  // Adding Reference
  references.add(new Reference((width - 100) / 4));
  references.add(new Reference((width - 100) / 4 * 2));
  references.add(new Reference((width - 100) / 4 * 3));
  references.add(new Reference((width - 100) / 4 * 4));
  // Adding Drums
  drums.put("Kick", new Drum(width/2 - width/6, height/2, palette.colors[2]));
  drums.put("Snare", new Drum(width/2, height/2, palette.colors[3]));
  drums.put("HH", new Drum(width/2 + width/6, height/2, palette.colors[4]));
}

void draw() {
  background(palette.colors[0]);
  // DEBUG SPEED
  //surface.setTitle(str(frameRate));
  /*** SHOW REFERENCE
  for (int i = 0; i < references.size(); i++) {
    Reference part = references.get(i);
    part.display();
  }
  if (play) {
    Reference flash = references.get(beat - 1);
    flash.flash();
  }
  */
  /*** SHOW DRUMS ***/
  drums.get("Kick").display();
  drums.get("Snare").display();
  drums.get("HH").display();
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
  // println("Channel: " + sm.getChannel() + " " + oct, NOTE_NAMES[note], msg);
  int msg = sm.getData1();
  int oct = (msg / 12) - 2;
  int note = msg % 12;
  
  if (sm.getCommand() == NOTE_ON) {
    if (NOTE_NAMES[note].equals("C") && oct == 1) {
      drums.get("Kick").animate();
    }
    if (NOTE_NAMES[note].equals("D") && oct == 1) {
      drums.get("Snare").animate();
    }
    if (NOTE_NAMES[note].equals("F#") && oct == 1) {
      drums.get("HH").animate();
    }
  }

  if (sm.getCommand() == NOTE_OFF) {
    if (NOTE_NAMES[note].equals("C") && oct == 1) {
      drums.get("Kick").reset();
    }
    if (NOTE_NAMES[note].equals("D") && oct == 1) {
      drums.get("Snare").reset();
    }
    if (NOTE_NAMES[note].equals("F#") && oct == 1) {
      drums.get("HH").reset();
    }
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
