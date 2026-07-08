import clsx from "clsx";

import "./ToolIcon.scss";

import { eyeIcon, eyeClosedIcon } from "./icons";

import type { ToolButtonSize } from "./ToolButton";

type BackgroundToggleButtonProps = {
  title?: string;
  checked: boolean;
  onChange?(): void;
  isMobile?: boolean;
};

const DEFAULT_SIZE: ToolButtonSize = "medium";

export const BackgroundToggleButton = (
  props: BackgroundToggleButtonProps,
) => {
  return (
    <label
      className={clsx(
        "ToolIcon ToolIcon__background-toggle",
        `ToolIcon_size_${DEFAULT_SIZE}`,
        {
          "is-mobile": props.isMobile,
        },
      )}
      title={props.title}
    >
      <input
        className="ToolIcon_type_checkbox"
        type="checkbox"
        onChange={props.onChange}
        checked={props.checked}
        aria-label={props.title}
        data-testid="toolbar-background-toggle"
      />
      <div className="ToolIcon__icon">
        {props.checked ? eyeClosedIcon : eyeIcon}
      </div>
    </label>
  );
};
