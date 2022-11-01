import { useBackend } from '../backend';
import { Button, Box, Section, Table, Divider, Tabs } from '../components';
import { Window } from '../layouts';

export const PipeDispenser = (props, context) => {
  const { act, data } = useBackend(context);

  let tabIndex = 0;

  const setTabIndex = (index) => {
    tabIndex = index;
  };

  const {
    Atmos,
    Disposals,
  } = data;
  return (
    <Window>
      <Window.Content scrollable>
        <Section>
          <Tabs>
            <Tabs.Tab
              selected={tabIndex === 1}
              onClick={() => setTabIndex(1)}>
              <Section title="Atmospheric Devices">
                {Atmos.map(device => {
                  return (
                    <>
                      <Table direction="row" align="center" key={device}>
                        <Table.Row>
                          <Table.Cell>
                            <Box bold>
                              {device}
                            </Box>
                          </Table.Cell>
                          <Table.Cell bold textAlign="right">
                            <Button
                              color="green"
                              content="Create"
                              onClick={() => act('createdevice', {
                                item: device })}
                            />
                          </Table.Cell>
                        </Table.Row>
                      </Table>
                      <Divider />
                    </>
                  );
                })}
              </Section>
            </Tabs.Tab>
            <Tabs.Tab
              selected={tabIndex === 2}
              onClick={() => setTabIndex(2)}>
              <Section title="Disposal Pipes">
                {Disposals.map(pipe => {
                  return (
                    <>
                      <Table direction="row" align="center" key={pipe}>
                        <Table.Row>
                          <Table.Cell>
                            <Box bold>
                              {pipe}
                            </Box>
                          </Table.Cell>
                          <Table.Cell bold textAlign="right">
                            <Button
                              color="green"
                              content="Create"
                              onClick={() => act('createpipe', {
                                item: pipe })}
                            />
                          </Table.Cell>
                        </Table.Row>
                      </Table>
                      <Divider />
                    </>
                  );
                })}
              </Section>
            </Tabs.Tab>
          </Tabs>
        </Section>
      </Window.Content>
    </Window>
  );
};
