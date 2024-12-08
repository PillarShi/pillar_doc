import os
import sys

def main(config_name, config_out_name):
    os.system("menuconfig")
    config = open(config_name, "r")
    config_cmake = open(config_out_name+".cmake","w")
    config_cmake.write("include_directories(.)")
    config_h = open(config_out_name+".h", "w")
    config_h_define = f"_{config_out_name.upper()}_H_"
    config_h.write(f"#ifndef {config_h_define}\n#define {config_h_define}\n\n")
    for line in config:
        line = line.replace('\n', '').replace('\r', '')
        line_size = len(line)
        if line_size == 0:
            continue
        elif line_size == 1:
            config_h.write("\n")
            config_cmake.write("\n")
            continue

        if line[0] == '#':
            if line[2] == 'C':
                config_h.write(f"/* {line[9:]} */\n")
                config_cmake.write(f"# {line[9:]}\n")
            else:
                config_h.write(f"/* {line[2:]} */\n")
                config_cmake.write(f"# {line[2:]}\n")
        else:
            line_message = line.split('=')
            if line_message[1] == "y":
                config_h.write(f"#define {line_message[0][7:]}\n")
                config_cmake.write(f"set({line_message[0][7:]} y)\n")
            else:
                config_h.write(f"#define {line_message[0][7:]} {line_message[1]}\n")
                config_cmake.write(f"set({line_message[0][7:]} {line_message[1]})\n")

    config_h.write(f"\n#endif /* {config_h_define} */\n")
    config_h.close()
    config_cmake.close()
    config.close()

if __name__ == "__main__":
    argc = len(sys.argv)
    if argc == 1:
        main(".config", "config")
    elif argc == 2:
        main(sys.argv[1], "config")
    elif argc == 3:
        main(sys.argv[1], sys.argv[2])
    else :
        print(f"python {sys.argv[0]} <.config input> <output name>")
        exit(1)