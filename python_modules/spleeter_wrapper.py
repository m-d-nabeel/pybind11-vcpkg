import spleeter
from spleeter.separator import Separator

def separate_audio(input_file, output_dir):
    separator = Separator('spleeter:2stems')
    separator.separate_to_file(input_file, output_dir)
    return True