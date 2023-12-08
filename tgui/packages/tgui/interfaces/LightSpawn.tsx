import { useBackend, useLocalState } from '../backend';
import { classes } from '../../common/react';
import { Box, Button, Knob, Section, Slider, Stack, Tabs } from '../components';
import { Window } from '../layouts';

enum Direction {
  North = 1,
  South = 2,
  East = 4,
  West = 8,
}

type LightDetails = {
  name: string;
  color: string;
  power: number;
  range: number;
  angle: number;
};

type TemplateID = string;

type LightTemplate = {
  light_info: LightDetails;
  description: string;
  id: TemplateID;
};

interface CategoryList {
  [key: string]: TemplateID[];
}

type Data = {
  templates: LightTemplate[];
  default_id: string;
  default_category: string;
  category_ids: CategoryList;
};

export const LightSpawn = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { templates = [], default_id, default_category, category_ids } = data;
  const [currentTemplate, setCurrentTemplate] = useLocalState<string>(
    context,
    'currentTemplate',
    default_id,
  );
  const [currentCategory, setCurrentCategory] = useLocalState<string>(
    context,
    'currentCategory',
    default_category,
  );

  const category_keys = category_ids ? Object.keys(category_ids) : [];

  return (
    <Window title={'Light Spawn'} width={600} height={400}>
      <Window.Content scrollable>
        <Stack vertical>
          <Stack.Item>
            <Section scrollable width="100%">
              <Tabs>
                {category_keys.map((category, index) => (
                  <Tabs.Tab
                    key={category}
                    selected={currentCategory === category}
                    onClick={() => setCurrentCategory(category)}
                    fontSize="14px"
                    bold
                    textColor="#eee"
                  >
                    {category}
                  </Tabs.Tab>
                ))}
              </Tabs>
              <Tabs>
                {category_ids[currentCategory].map((id) => (
                  <Tabs.Tab
                    key={id}
                    selected={currentTemplate === id}
                    onClick={() => setCurrentTemplate(id)}
                  >
                    <Stack vertical>
                      <Stack.Item
                        align="center"
                        className={classes([
                          'lights32x32',
                          'light_fantastic_' + id,
                        ])}
                      />
                      <Stack.Item fontSize="14px" textColor="#cee" nowrap>
                        {templates[id].light_info.name}
                      </Stack.Item>
                    </Stack>
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <LightInfo light={templates[currentTemplate]} />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

type LightInfoProps = {
  light: LightTemplate;
};

const LightInfo = (props: LightInfoProps, context) => {
  const { act } = useBackend(context);
  const { light } = props;
  const { light_info } = light;
  const [workingDir, setWorkingDir] = useLocalState<number>(
    context,
    'workingDir',
    Direction.North,
  );
  return (
    <Section>
      <Stack vertical justify="space-between" fill>
        <Stack.Item>
          <Stack>
            <Stack.Item>
              <Section title="Direction" textAlign="center" fontSize="11px">
                <DirectionSelect />
              </Section>
            </Stack.Item>
            <Stack.Item>
              <Section title="Angle" textAlign="center" fontSize="11px">
                <AngleSelect angle={light_info.angle} />
              </Section>
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item>
          <Stack justify="space-between">
            <Stack.Item>
              <Box fontSize="16px" mt={0.5}>
                Template: {light_info.name}
              </Box>
              <Box fontSize="12px" ml={1} color="#aaaaaa">
                {light.description}
              </Box>
            </Stack.Item>
            <Stack.Item>
              <Button fontSize="16px" icon="brush" textColor={light_info.color}>
                {light_info.color}
              </Button>
              <Button
                fontSize="16px"
                icon="wrench"
                tooltip="Spawn template"
                onClick={() =>
                  act('spawn_template', {
                    id: light.id,
                    dir: workingDir,
                  })
                }
              />
            </Stack.Item>
          </Stack>
        </Stack.Item>
        <Stack.Item align="end">
          <Slider
            unit="tiles"
            value={light_info.range}
            color="blue"
            minValue={0}
            maxValue={10}
            step={0}
          />
          <Slider
            unit="intensity"
            value={light_info.power}
            color="olive"
            minValue={-1}
            maxValue={5}
            step={0}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

// 3 vertical stacks, setup as columns
const DirectionSelect = () => {
  return (
    <Stack align="start" mt={0.5}>
      <Stack.Item align="center">
        <DirectionButton icon="arrow-left" dir={Direction.West} />
      </Stack.Item>
      <Stack.Item>
        <Stack vertical>
          <Stack.Item>
            <DirectionButton icon="arrow-up" dir={Direction.North} />
          </Stack.Item>
          <Stack.Item>
            <Box backgroundColor="grey" width="18px" height="18px" ml="2px" />
          </Stack.Item>
          <Stack.Item>
            <DirectionButton icon="arrow-down" dir={Direction.South} />
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item align="center">
        <DirectionButton icon="arrow-right" dir={Direction.East} />
      </Stack.Item>
    </Stack>
  );
};

type DirectedButtonProps = {
  dir: number;
  icon: string;
};

const DirectionButton = (props: DirectedButtonProps, context) => {
  const { act, data } = useBackend<Data>(context);
  const { dir, icon } = props;
  const [workingDir, setWorkingDir] = useLocalState<number>(
    context,
    'workingDir',
    Direction.North,
  );
  return (
    <Button
      icon={icon}
      selected={workingDir & dir}
      onClick={() => setWorkingDir(dir)}
    />
  );
};

const AngleSelect = (props, context) => {
  const { act, data } = useBackend<Data>(context);
  const { angle } = props;
  return (
    <Knob
      mt={0.5}
      value={angle}
      minValue={0}
      maxValue={360}
      animated
      size={2.2}
      step={5}
      stepPixelSize={10}
    />
  );
};
