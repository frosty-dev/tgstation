import { sortBy } from 'common/collections';
import { classes } from 'common/react';
import { useLocalState } from '../../backend';
import { Flex, Button, Stack, AnimatedNumber } from '../../components';
import { formatSiUnit } from '../../format';
import { MaterialIcon } from './MaterialIcon';
import { Material } from './Types';

// by popular demand of discord people (who are always right and never wrong)
// this is completely made up
const MATERIAL_RARITY: Record<string, number> = {
  стекло: 0,
  железо: 1,
  пластик: 2,
  титан: 3,
  плазма: 4,
  серебро: 5,
  золото: 6,
  уран: 7,
  алмаз: 8,
  'блюспейс кристалл': 9,
  бананиум: 10,
};

const MATERIAL_RU_TO_EN: Record<string, string> = {
  стекло: 'glass',
  железо: 'iron',
  пластик: 'plastic',
  титан: 'titanium',
  плазма: 'plasma',
  серебро: 'silver',
  золото: 'gold',
  уран: 'uranium',
  алмаз: 'diamond',
  'блюспейс кристалл': 'bluespace crystal',
  бананиум: 'bananium',
};

export type MaterialAccessBarProps = {
  /**
   * All materials currently available to the user.
   */
  availableMaterials: Material[];

  /**
   * Definition of how much units 1 sheet has.
   */
  SHEET_MATERIAL_AMOUNT: number;

  /**
   * Invoked when the user requests that a material be ejected.
   */
  onEjectRequested?: (material: Material, quantity: number) => void;
};

/**
 * The formatting function applied to the quantity labels in the bar.
 */
const LABEL_FORMAT = (value: number) => formatSiUnit(value, 0);

/**
 * A bottom-docked bar for viewing and ejecting materials from local storage or
 * the ore silo. Has pop-out docks for each material type for ejecting up to
 * fifty sheets.
 */
export const MaterialAccessBar = (props: MaterialAccessBarProps, context) => {
  const { availableMaterials, SHEET_MATERIAL_AMOUNT, onEjectRequested } = props;

  return (
    <Flex wrap>
      {sortBy((m: Material) => MATERIAL_RARITY[m.name])(availableMaterials).map(
        (material) => (
          <Flex.Item key={material.name} grow={1}>
            <MaterialCounter
              material={material}
              SHEET_MATERIAL_AMOUNT={SHEET_MATERIAL_AMOUNT}
              onEjectRequested={(quantity) =>
                onEjectRequested && onEjectRequested(material, quantity)
              }
            />
          </Flex.Item>
        )
      )}
    </Flex>
  );
};

type MaterialCounterProps = {
  material: Material;
  SHEET_MATERIAL_AMOUNT: number;
  onEjectRequested: (quantity: number) => void;
};

const MaterialCounter = (props: MaterialCounterProps, context) => {
  const { material, onEjectRequested, SHEET_MATERIAL_AMOUNT } = props;

  const [hovering, setHovering] = useLocalState(
    context,
    `MaterialCounter__${material.name}`,
    false
  );

  const sheets = material.amount / SHEET_MATERIAL_AMOUNT;

  return (
    <div
      onMouseEnter={() => setHovering(true)}
      onMouseLeave={() => setHovering(false)}
      className={classes([
        'MaterialDock',
        hovering && 'MaterialDock--active',
        sheets < 1 && 'MaterialDock--disabled',
      ])}
    >
      <Stack vertial direction={'column-reverse'}>
        <Flex
          direction="column"
          textAlign="center"
          onClick={() => onEjectRequested(1)}
          className="MaterialDock__Label"
        >
          <Flex.Item>
            <MaterialIcon
              materialName={MATERIAL_RU_TO_EN[material.name]}
              sheets={sheets}
            />
          </Flex.Item>
          <Flex.Item>
            <AnimatedNumber value={sheets} format={LABEL_FORMAT} />
          </Flex.Item>
        </Flex>
        {hovering && (
          <div className={'MaterialDock__Dock'}>
            <Flex vertical direction={'column-reverse'}>
              <EjectButton
                sheets={sheets}
                amount={5}
                onEject={onEjectRequested}
              />
              <EjectButton
                sheets={sheets}
                amount={10}
                onEject={onEjectRequested}
              />
              <EjectButton
                sheets={sheets}
                amount={25}
                onEject={onEjectRequested}
              />
              <EjectButton
                sheets={sheets}
                amount={50}
                onEject={onEjectRequested}
              />
            </Flex>
          </div>
        )}
      </Stack>
    </div>
  );
};

type EjectButtonProps = {
  amount: number;
  sheets: number;
  onEject: (quantity: number) => void;
};

const EjectButton = (props: EjectButtonProps, context) => {
  const { amount, sheets, onEject } = props;

  return (
    <Button
      fluid
      color={'transparent'}
      className={classes([
        'Fabricator__PrintAmount',
        amount > sheets && 'Fabricator__PrintAmount--disabled',
      ])}
      onClick={() => onEject(amount)}
    >
      &times;{amount}
    </Button>
  );
};
