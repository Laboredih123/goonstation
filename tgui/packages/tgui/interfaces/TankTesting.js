import { useBackend } from '../backend';
import { Button, Flex, Knob, NumberInput, RoundGauge, Section } from '../components';
import { Window } from '../layouts';
import { formatPressure } from '../format';

export const TankTesting = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    oxygen1,
    plasma1,
    pressure1,
    temp1,
    oxygen2,
    plasma2,
    pressure2,
    temp2,
    pressure3,
    tankleak,
    tankbreak,
    tankblow,
    tank3integrity,
    tank3range,
    events,
  } = data;

  return (
    <Window
      width={450}
      height={470}>
      <Window.Content>
        <Section
          title="Tank 1">
          <Knob
            size={1.75}
            value={pressure1}
            minValue={0}
            maxValue={1013.25}
            ranges={{
              "good": [0, 709.275],
              "average": [709.275, 861.2625],
              "bad": [861.2625, 1013.25],
            }}
            format={formatPressure}
            onDrag={(e, value) => act('adjustpres1', { kpa: value })}
          />
          <NumberInput
            animated
            size={1.75}
            value={oxygen1}
            minValue={0}
            maxValue={100}
            format={value => value + " % oxygen"}
            onChange={(e, value) => act('adjustoxy1', { percent: value })}
          />
          <NumberInput
            animated
            size={1.75}
            value={plasma1}
            minValue={0}
            maxValue={100}
            format={value => value + " % plasma"}
            onChange={(e, value) => act('adjusttox1', { percent: value })}
          />
          <NumberInput
            animated
            size={1.75}
            value={temp1}
            minValue={0}
            maxValue={8000}
            format={value => value + " Kelvin"}
            onChange={(e, value) => act('adjusttemp1', { kelvin: value })}
          />
        </Section>
        <Section
          title="Tank 2">
          <Knob
            size={1.75}
            value={pressure2}
            minValue={0}
            maxValue={1013.25}
            ranges={{
              "good": [0, 709.275],
              "average": [709.275, 861.2625],
              "bad": [861.2625, 1013.25],
            }}
            format={formatPressure}
            onDrag={(e, value) => act('adjustpres2', { kpa: value })}
          />
          <NumberInput
            animated
            size={1.75}
            value={oxygen2}
            minValue={0}
            maxValue={100}
            format={value => value + " % oxygen"}
            onChange={(e, value) => act('adjustoxy2', { percent: value })}
          />
          <NumberInput
            animated
            size={1.75}
            value={plasma2}
            minValue={0}
            maxValue={100}
            format={value => value + " % plasma"}
            onChange={(e, value) => act('adjusttox2', { percent: value })}
          />
          <NumberInput
            animated
            size={1.75}
            value={temp2}
            minValue={0}
            maxValue={8000}
            format={value => value + " Kelvin"}
            onChange={(e, value) => act('adjusttemp2', { kelvin: value })}
          />
        </Section>
        <Section
          title="Result">
          <Flex
            direction="column">
            <Flex.Item>
              <RoundGauge
                size={1.75}
                value={pressure3}
                minValue={0}
                maxValue={tankblow*1.5}
                alertAfter={tankbreak}
                ranges={{
                  "green": [0, tankleak],
                  "yellow": [tankleak, tankbreak],
                  "orange": [tankbreak, tankblow],
                  "red": [tankblow, tankblow*1.5],
                }}
                format={formatPressure}
              />
            </Flex.Item>
            <Flex.Item>
              <RoundGauge
                size={1.75}
                value={tank3integrity}
                minValue={0}
                maxValue={3}
                alertBefore={2}
                ranges={{
                  "good": [2, 3],
                  "average": [1, 2],
                  "bad": [0, 1],
                }}
                format={value => value + " Integrity"}
              />
            </Flex.Item>
            <Flex.Item>
              <Button
                onClick={() => act('step')}>
                Step Reaction
              </Button>
            </Flex.Item>
            <Flex.Item>
              <Button
                onClick={() => act('mix')}>
                Mix
              </Button>
            </Flex.Item>
            <Flex.Item>
              <Button
                onClick={() => act('reset')}>
                Reset
              </Button>
            </Flex.Item>
            <Flex.Item>
              Range of blow up: {tank3range}
            </Flex.Item>
            <Flex.Item>
              Current Actions
              <br />
              {events}
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );

};
