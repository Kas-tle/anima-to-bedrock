#!/bin/bash

# generate armor_stand initial entity file
jq -n "{\"format_version\": \"1.10.0\",\"minecraftcolonclient_entity\": {\"description\": {\"identifier\": \"minecraft:armor_stand\",\"min_engine_version\": \"1.8.0\",\"materials\": {\"default\": \"armor_stand\"},\"textures\": {\"default\": \"textures/entity/armor_stand\"},\"animations\": {\"default_pose\": \"animation.armor_stand.default_pose\",\"no_pose\": \"animation.armor_stand.no_pose\",\"solemn_pose\": \"animation.armor_stand.solemn_pose\",\"athena_pose\": \"animation.armor_stand.athena_pose\",\"brandish_pose\": \"animation.armor_stand.brandish_pose\",\"honor_pose\": \"animation.armor_stand.honor_pose\",\"entertain_pose\": \"animation.armor_stand.entertain_pose\",\"salute_pose\": \"animation.armor_stand.salute_pose\",\"riposte_pose\": \"animation.armor_stand.riposte_pose\",\"zombie_pose\": \"animation.armor_stand.zombie_pose\",\"cancan_a_pose\": \"animation.armor_stand.cancan_a_pose\",\"cancan_b_pose\": \"animation.armor_stand.cancan_b_pose\",\"hero_pose\": \"animation.armor_stand.hero_pose\",\"wiggle\": \"animation.armor_stand.wiggle\",\"controller.pose\": \"controller.animation.armor_stand.pose\",\"controller.wiggling\": \"controller.animation.armor_stand.wiggle\"},\"scripts\": {\"initialize\": [\"variable.armor_stand.pose_index = 0;\",\"variable.armor_stand.hurt_time = 0;\"],\"animate\": [\"controller.pose\",\"controller.wiggling\"]},\"geometry\": {\"default\": \"geometry.armor_stand\"},\"render_controllers\": [ \"controller.render.armor_stand\" ],\"enable_attachables\": true}}}" > armor_stand.v1.0.entity.json
printf "Generated initial armorstand entity file: \e[33marmor_stand.v1.0.entity.json\e[m\n"

# iterate over all .anima files
for file in *.anima
   do
   # ensure our anima is indeed a json... lord animatronics, why
   cat ${file} | yq . | sponge ${file}
   # set initial values for animation name and frame number from input anima
   animation_name=($(jq -r ".Animatronic | keys[]" ${file}))
   frame_number=($(jq ".Animatronic.${animation_name}.poslist?[]?" ${file}))

   #setup initial animation system in anima & deal with frame_number[0] first
   jq ". + {\"format_version\":\"1.8.0 \",\"animations\": {\"animation.armor_stand.${animation_name}\": {\"loop\": true,\"animation_length\": 0.0,\"bones\": {\"baseplate\": {\"rotation\": {\"0.0\": {\"post\": [0, (.Animatronic.${animation_name}.${frame_number[0]} | (.yaw? //0)), 0],\"lerp_mode\":\"catmullrom\" } },\"position\": {\"0.0\": {\"post\": [0, 0, 0],\"lerp_mode\":\"catmullrom\" } } },\"bodya\": {\"rotation\": {\"0.0\": {\"post\": [remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.bx? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.by? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.bz? //0) * 57.3; 360)],\"lerp_mode\":\"catmullrom\" } } },\"head\": {\"rotation\": {\"0.0\": {\"post\": [remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.hx? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.hy? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.hz? //0) * 57.3; 360)],\"lerp_mode\":\"catmullrom\" } } },\"leftarm\": {\"rotation\": {\"0.0\": {\"post\": [remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.lax? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.lay? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.laz? //0) * 57.3; 360)],\"lerp_mode\":\"catmullrom\" } } },\"leftleg\": {\"rotation\": {\"0.0\": {\"post\": [remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.llx? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.lly? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.llz? //0) * 57.3; 360)],\"lerp_mode\":\"catmullrom\" } } },\"rightarm\": {\"rotation\": {\"0.0\": {\"post\": [remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.rax? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.ray? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.raz? //0) * 57.3; 360)],\"lerp_mode\":\"catmullrom\" } } },\"rightleg\": {\"rotation\": {\"0.0\": {\"post\": [remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.rlx? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.rly? //0) * 57.3; 360), remainder(.Animatronic.${animation_name}.${frame_number[0]} | (.rlz? //0) * 57.3; 360)],\"lerp_mode\":\"catmullrom\" } } } } } } }" ${file} | sponge armor_stand.${animation_name}.json
   printf "Frame \e[33m${frame_number[0]}\e[m added for \e[33marmor_stand.${animation_name}.json\e[m\n"

   # ensure frame_number[0] has a delay value
   jq ".Animatronic.${animation_name}.${frame_number[0]} += {delay: (.Animatronic.${animation_name}.${frame_number[0]}.delay // .Animatronic.${animation_name}.delay|tostring)}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json

   printf "Now attempting to add the following frames for \e[33marmor_stand.${animation_name}.json\e[m:\n"
   echo ${frame_number[@]:1}

   for i in "${frame_number[@]:1}"
     do
     array_index=($(echo ${frame_number[@]/$i//} | cut -d/ -f1 | wc -w | tr -d ' '))
     readable_index=($(expr 1 + $array_index))
     previous_index=($(expr $array_index - 1))
     # we must first ensure this frame has delay. If not we, will use the universal delay value
     jq ".Animatronic.${animation_name}.${i} += {delay: (.Animatronic.${animation_name}.${i}.delay // .Animatronic.${animation_name}.delay|tostring)}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     # set variables to calculate frame value
     last_frame_delay_ticks=($(jq -r ".Animatronic.${animation_name}.${frame_number[${previous_index}]}.delay" armor_stand.${animation_name}.json))
     #increment with each frame calculated
     ((current_total_delay_ticks=current_total_delay_ticks+last_frame_delay_ticks))
     this_frame_seconds=($(echo "${current_total_delay_ticks} 20" | awk '{print $1 / $2}'))
     # begin replacements by frame
     # armor_stand yaw
     jq ".animations.\"animation.armor_stand.${animation_name}\".bones.baseplate.rotation += {\"${this_frame_seconds}\": {\"post\": [0, (.Animatronic.${animation_name}.${i} | (.yaw? // 0)), 0], \"lerp_mode\": \"catmullrom\"}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     # armor_stand position
     jq ".animations.\"animation.armor_stand.${animation_name}\".bones.baseplate.position += {\"${this_frame_seconds}\": {\"post\": [((.Animatronic.${animation_name}.${frame_number[0]}.x - .Animatronic.${animation_name}.${i}.x) * 16), ((.Animatronic.${animation_name}.${frame_number[0]}.y - .Animatronic.${animation_name}.${i}.y) * 16), ((.Animatronic.${animation_name}.${frame_number[0]}.z - .Animatronic.${animation_name}.${i}.z) * 16)], \"lerp_mode\": \"catmullrom\"}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     # bone bodya
     jq ".animations.\"animation.armor_stand.${animation_name}\".bones.bodya.rotation += {\"${this_frame_seconds}\": {\"post\": [remainder(.Animatronic.${animation_name}.${i}.bx * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.by * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.bz * 57.3; 360)], \"lerp_mode\": \"catmullrom\"}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     # bone head
     jq ".animations.\"animation.armor_stand.${animation_name}\".bones.head.rotation += {\"${this_frame_seconds}\": {\"post\": [remainder(.Animatronic.${animation_name}.${i}.hx * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.hy * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.hz * 57.3; 360)], \"lerp_mode\": \"catmullrom\"}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     # bone leftarm
     jq ".animations.\"animation.armor_stand.${animation_name}\".bones.leftarm.rotation += {\"${this_frame_seconds}\": {\"post\": [remainder(.Animatronic.${animation_name}.${i}.lax * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.lay * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.laz * 57.3; 360)], \"lerp_mode\": \"catmullrom\"}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     # bone leftleg
     jq ".animations.\"animation.armor_stand.${animation_name}\".bones.leftleg.rotation += {\"${this_frame_seconds}\": {\"post\": [remainder(.Animatronic.${animation_name}.${i}.llx * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.lly * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.llz * 57.3; 360)], \"lerp_mode\": \"catmullrom\"}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     # bone rightarm
     jq ".animations.\"animation.armor_stand.${animation_name}\".bones.rightarm.rotation += {\"${this_frame_seconds}\": {\"post\": [remainder(.Animatronic.${animation_name}.${i}.rax * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.ray * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.raz * 57.3; 360)], \"lerp_mode\": \"catmullrom\"}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     #bone rightleg
     jq ".animations.\"animation.armor_stand.${animation_name}\".bones.rightleg.rotation += {\"${this_frame_seconds}\": {\"post\": [remainder(.Animatronic.${animation_name}.${i}.rlx * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.rly * 57.3; 360), remainder(.Animatronic.${animation_name}.${i}.rlz * 57.3; 360)], \"lerp_mode\": \"catmullrom\"}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
     printf "Frame \e[33m${i}\e[m added for \e[33marmor_stand.${animation_name}.json\e[m\n"
     # set animations for items in array after 0
   done
   # set total animation length
   total_frame_seconds=($(jq -r ".animations.\"animation.armor_stand.${animation_name}\".bones.baseplate.rotation | keys[-1]" armor_stand.${animation_name}.json))
   jq ".animations.\"animation.armor_stand.${animation_name}\" += {\"animation_length\": ${total_frame_seconds}}" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json
   # reset current_total_delay_ticks
   current_total_delay_ticks=0
   # append animation to armor_stand entity file
   jq ".minecraftcolonclient_entity.description.animations += {\"${animation_name}\": \"animation.armor_stand.${animation_name}\"}" armor_stand.v1.0.entity.json | sponge armor_stand.v1.0.entity.json
   jq ".minecraftcolonclient_entity.description.scripts.animate += [\"${animation_name}\"]" armor_stand.v1.0.entity.json | sponge armor_stand.v1.0.entity.json

   # remove Animatronic component
   jq "del(.Animatronic)" armor_stand.${animation_name}.json | sponge armor_stand.${animation_name}.json

done

# deal with jq being literally brain dead
{ rm armor_stand.v1.0.entity.json && awk '{gsub("minecraftcolonclient_entity", "minecraft:client_entity", $0); print}' > armor_stand.v1.0.entity.json; } < armor_stand.v1.0.entity.json

# done
printf "\e[32mAll animations have been successfully generated.\e[m\n"
