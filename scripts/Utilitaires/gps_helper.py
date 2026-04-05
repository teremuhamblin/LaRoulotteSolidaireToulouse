#!/usr/bin/env python3
# ==============================================================================
#  GPS Helper – La Roulotte Solidaire Toulouse
#  Fonctions : distance, direction, formatage GPS
# ==============================================================================

import math
import argparse
from datetime import datetime

CYAN = "\033[96m"
GREEN = "\033[92m"
YELLOW = "\033[93m"
RESET = "\033[0m"

def banner():
    print(f"{CYAN}=== GPS Helper – La Route ==={RESET}")

def haversine(lat1, lon1, lat2, lon2):
    R = 6371
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat/2)**2 + math.cos(math.radians(lat1)) \
        * math.cos(math.radians(lat2)) * math.sin(dlon/2)**2
    return R * (2 * math.atan2(math.sqrt(a), math.sqrt(1 - a)))

def direction(lat1, lon1, lat2, lon2):
    dlon = math.radians(lon2 - lon1)
    y = math.sin(dlon) * math.cos(math.radians(lat2))
    x = math.cos(math.radians(lat1)) * math.sin(math.radians(lat2)) \
        - math.sin(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.cos(dlon)
    brng = (math.degrees(math.atan2(y, x)) + 360) % 360
    return brng

def main():
    banner()
    parser = argparse.ArgumentParser(description="Outils GPS pour la route")
    parser.add_argument("lat1", type=float)
    parser.add_argument("lon1", type=float)
    parser.add_argument("lat2", type=float)
    parser.add_argument("lon2", type=float)
    args = parser.parse_args()

    dist = haversine(args.lat1, args.lon1, args.lat2, args.lon2)
    brng = direction(args.lat1, args.lon1, args.lat2, args.lon2)

    print(f"{GREEN}Distance : {dist:.2f} km{RESET}")
    print(f"{YELLOW}Direction : {brng:.1f}°{RESET}")

if __name__ == "__main__":
    main()
