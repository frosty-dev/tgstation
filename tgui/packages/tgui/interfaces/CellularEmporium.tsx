import { BooleanLike } from '../../common/react';
import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Section,
  Icon,
  Input,
  Stack,
  LabeledList,
  Box,
  NoticeBox,
} from '../components';
import { Window } from '../layouts';

type typePath = string;

type CellularEmporiumContext = {
  abilities: Ability[];
  can_readapt: BooleanLike;
  genetic_points_count: number;
  owned_abilities: typePath[];
  absorb_count: number;
  dna_count: number;
};

type Ability = {
  name: string;
  desc: string;
  helptext: string;
  path: typePath;
  genetic_point_required: number; // Checks against genetic_points_count
  absorbs_required: number; // Checks against absorb_count
  dna_required: number; // Checks against dna_count
};

export const CellularEmporium = (props, context) => {
  const { act, data } = useBackend<CellularEmporiumContext>(context);
  const [searchAbilities, setSearchAbilities] = useLocalState(
    context,
    'searchAbilities',
    ''
  );

  const { can_readapt, genetic_points_count } = data;
  return (
    <Window width={900} height={480}>
      <Window.Content>
        <Section
          fill
          scrollable
          title={'Генетические очки'}
          buttons={
            <Stack>
              <Stack.Item fontSize="16px">
                {genetic_points_count && genetic_points_count}{' '}
                <Icon name="dna" color="#DD66DD" />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="undo"
                  content="Переадаптировать"
                  color="good"
                  disabled={!can_readapt}
                  tooltip={
                    can_readapt
                      ? 'Мы переадаптируемся, отменяя все эволюционные способности \
                    и возвращая генетические очки.'
                      : 'Мы не можем переадаптироваться, пока не поглотим больше ДНК.'
                  }
                  onClick={() => act('readapt')}
                />
              </Stack.Item>
              <Stack.Item>
                <Input
                  width="200px"
                  onInput={(event) => setSearchAbilities(event.target.value)}
                  placeholder="Search Abilities..."
                  value={searchAbilities}
                />
              </Stack.Item>
            </Stack>
          }
        >
          <AbilityList />
        </Section>
      </Window.Content>
    </Window>
  );
};

const AbilityList = (props, context) => {
  const { act, data } = useBackend<CellularEmporiumContext>(context);
  const [searchAbilities] = useLocalState(context, 'searchAbilities', '');
  const {
    abilities,
    owned_abilities,
    genetic_points_count,
    absorb_count,
    dna_count,
  } = data;

  const filteredAbilities =
    searchAbilities.length <= 1
      ? abilities
      : abilities.filter((ability) => {
          return (
            ability.name
              .toLowerCase()
              .includes(searchAbilities.toLowerCase()) ||
            ability.desc
              .toLowerCase()
              .includes(searchAbilities.toLowerCase()) ||
            ability.helptext
              .toLowerCase()
              .includes(searchAbilities.toLowerCase())
          );
        });

  if (filteredAbilities.length === 0) {
    return (
      <NoticeBox>
        {abilities.length === 0
          ? 'Нет доступных способностей для покупки. \
          Это ошибка, свяжитесь с кодером.'
          : 'Способности не найдены.'}
      </NoticeBox>
    );
  } else {
    return (
      <LabeledList>
        {filteredAbilities.map((ability) => (
          <LabeledList.Item
            key={ability.name}
            className="candystripe"
            label={ability.name}
            buttons={
              <Stack>
                <Stack.Item>{ability.genetic_point_required}</Stack.Item>
                <Stack.Item>
                  <Icon
                    name="dna"
                    color={
                      owned_abilities.includes(ability.name)
                        ? '#DD66DD'
                        : 'gray'
                    }
                  />
                </Stack.Item>
                <Stack.Item>
                  <Button
                    content={'Развить'}
                    disabled={
                      owned_abilities.includes(ability.name) ||
                      ability.genetic_point_required > genetic_points_count ||
                      ability.absorbs_required > absorb_count ||
                      ability.dna_required > dna_count
                    }
                    onClick={() =>
                      act('evolve', {
                        name: ability.name,
                      })
                    }
                  />
                </Stack.Item>
              </Stack>
            }
          >
            {ability.desc}
            <Box color="good">{ability.helptext}</Box>
          </LabeledList.Item>
        ))}
      </LabeledList>
    );
  }
};
