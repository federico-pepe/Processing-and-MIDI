// Midi Message Visualization
// by Federico Pepe
// http://www.federicopepe.com

import themidibus.*; //Import the library
import javax.sound.midi.MidiMessage; //Import the MidiMessage classes https://docs.oracle.com/javase/7/docs/api/javax/sound/midi/MidiMessage.html
import javax.sound.midi.ShortMessage; //Import the MidiMessage classes https://docs.oracle.com/javase/7/docs/api/javax/sound/midi/ShortMessage.html

// MIDI NOTES
int note;
int velocity;
// GUI 
int margin = 0;
int tempPadding = 0;
int displayW;
int keyWidth;
// OBJECTS
ArrayList<Piano> keys = new ArrayList<Piano>();

MidiBus myBus;
ShortMessage myShortMessage;

void setup() {
  /* GUI */
  size(800, 480);
  background(0);
  displayW = width;
  margin = calculatePadding(displayW)/2;
  keyWidth = width/128;
  /* MIDI SETUP */
  MidiBus.list();
  /* CHECK THE MIDIBUS DOCS TO SET IT UP CORRECTLY */
  myBus = new MidiBus(this, 0, 1);
}

void draw() {
  background(0);
  for(int i = 0; i < keys.size(); i++) {
    Piano thisPiano = keys.get(i);
    thisPiano.display();
    thisPiano.fade();
    if (thisPiano.isEnd(thisPiano)) {
      keys.remove(thisPiano);
    }
  }
}

void midiMessage(MidiMessage message) {
  /* MIDI Commands:
   * Docs: http://docs.oracle.com/javase/7/docs/api/javax/sound/midi/ShortMessage.html#ShortMessage()
   * Eg. 144 = NOTE_ON; 128 = NOTE_OFF
   * Data1, the data in this field varies and depends on Message Type.
   * Eg. could be the Note number or the CC Number
   * Data2, the data in this field varies and depends on Message Type
   * Eg. Velocity, Pressure, or Data
   */
  myShortMessage = (ShortMessage) message;
  // DEBUGGING MIDI DATA
  // println("MIDI Channel: " + myShortMessage.getChannel());
  // println("MIDI Command : " + myShortMessage.getCommand());
  // println("Data1 : " + myShortMessage.getData1());
  // println("Data 2: " + myShortMessage.getData2());
  velocity = myShortMessage.getData2();
  note = myShortMessage.getData1 ();
  if(myShortMessage.getCommand() == 144) {
    Piano p = new Piano(margin+(myShortMessage.getData1()*keyWidth), keyWidth, myShortMessage.getData2()*2);
    keys.add(p);
  }
}

int calculatePadding(int displayW) {  
  if (displayW % 128 != 0) {
    displayW--;
    calculatePadding(displayW);
    tempPadding++;
  }
  //println("Display W: " + displayW + " tempPadding" + tempPadding);
  return tempPadding;
}