#include <ESP8266WiFi.h>

// Pins
int hallSensorPin = A0;
uint8_t M1DIR = D1;
uint8_t M1PWM = D2;

// PID Variables
int force = 0;
int hallSensorVal;
int setValue = 750;
double K_p = 9.4 / 2.0;
double K_i = 19.8 / 2.0;
double K_d = 0.05 / 0.2;
double P = 0;
double I = 0;
double D = 0;
unsigned long t_prev = 0;
unsigned long t_curr = 0;
double dt = 0;
int e_prev = 0;
int e_curr = 0;
double de = 0;

void setup()
{
    Serial.begin(115200);
    Serial.println();

    /*Serial.print("Setting soft-AP ... ");
  Serial.println(WiFi.softAP("ESPsoftAP_01", "pass-to-soft-AP") ? "Ready" : "Failed!");
  Serial.println(WiFi.localIP());*/

    analogWriteFreq(20000);

    pinMode(hallSensorPin, INPUT);
    pinMode(M1DIR, OUTPUT);
    pinMode(M1PWM, OUTPUT);
    digitalWrite(M1DIR, LOW);
    digitalWrite(M1PWM, LOW);
}

void loop()
{

    // Get Feedback
    hallSensorVal = analogRead(hallSensorPin);

    t_prev = t_curr;
    t_curr = millis();
    dt = t_curr - t_prev;
    if (dt <= 0)
        return;

    e_prev = e_curr;
    e_curr = setValue - hallSensorVal;
    de = e_curr - e_prev;

    P = e_curr * K_p;
    I = I + K_i * e_curr * dt;
    D = K_d * de / dt;

    force = P + I + D;

    // limit values
    if (force >= 1024)force = 1023;
    else if (force <= 0)force = 0;
    if (I >= 1024)I = 1023;
    else if (I <= 0)I = 0;

    eMagnet(HIGH, force);

    //
    Serial.print("Input(pwm):");
    Serial.print(force);
    Serial.print(" Output:");
    Serial.print(hallSensorVal);
    Serial.print(" setValue:");
    Serial.print(setValue);
    Serial.print(" P:");
    Serial.print(P);
    Serial.print(" I:");
    Serial.print(I);
    Serial.print(" D:");
    Serial.print(D);
    Serial.println(" ");

    delay(20);
}

void eMagnet(int polarity, int force)
{
    digitalWrite(M1DIR, polarity);
    analogWrite(M1PWM, force);
}

void serialCommand(char command)
{
    char output[255];

    switch (command)
    {
    case 'P':
        gKp += KP_INCREMENT;
        break;
    case 'p':
        gKp -= KP_INCREMENT;
        if (0 > gKp)
            gKp = 0;
        break;

    case 'D':
        gKd += KD_INCREMENT;
        break;
    case 'd':
        gKd -= KD_INCREMENT;
        if (0 > gKd)
            gKd = 0;
        break;

    case 'I':
        gKi += KI_INCREMENT;
        break;
    case 'i':
        gKi -= KI_INCREMENT;
        if (0 > gKi)
            gKi = 0;
        break;

    case 'T':
        gTargetValue += VALUE_INCREMENT;
        break;
    case 't':
        gTargetValue -= VALUE_INCREMENT;
        if (0 > gTargetValue)
            gTargetValue = 0;
        break;

    //Print current settings. Also printed after any of the above cycles.
    case 'V':
    case 'v':
        break;

    //Ignore unrecognised characters
    default:
        return;
    }

    //Why so complicated? Arduino doesn't include support for %f by default and requires an additional library, so we rip it open manually. Will not support negative numbers or indefinite precision.
    //This one line causes 3026 bytes of ROM to be used, almost half the sketch size...so if you run out of space, disable this (or simplify it).
    sprintf(output, "Target Value: [%3d] Current PWM duty cycle [%3d] Current sensor value [%4d] Kp [%2d.%02d] Kd [%2d.%02d] Ki,Integral Error [.%04d,%d] Idle timeout [%d]\n",
            gTargetValue,
            gCurrentDutyCycle,
            gNextSensorReadout,
            (int)(gKp + 0.0001),
            roundValue(gKp * 100) % 100,
            (int)(gKd + 0.0001),
            roundValue(gKd * 100) % 100,
            roundValue(gKi * 10000) % 10000,
            gIntegralError,
            gIdleTime);

    Serial.print(output);
}

void loop()[

]
