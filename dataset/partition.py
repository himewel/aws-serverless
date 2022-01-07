import pandas as pd
import numpy as np

region_list = [
    "north",
    # "northeast",
    # "south",
    # "southeast",
    # "central_west",
]

for region in region_list:
    print(region)
    df = pd.read_csv(f"./archive/{region}.csv")
    for id, df_i in enumerate(np.array_split(df, 400)):
        print(id)
        df_i.to_csv(
            "s3://landing-2152/{region}/{region}_{id}.csv",
            index=False,
        )
