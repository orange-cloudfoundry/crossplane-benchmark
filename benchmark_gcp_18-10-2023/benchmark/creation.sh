#!/bin/bash
rm $(pwd)/benchmark/out/*.yaml
for i in `seq 1 9000`;
do
cp $(pwd)/benchmark/recordset.yaml $(pwd)/benchmark/out/$i.yaml
sed -i "s/__ID__/$i/" $(pwd)/benchmark/out/$i.yaml
kubectl apply --wait=false -f $(pwd)/benchmark/out/$i.yaml
sleep 1s
done
echo 'Generation done'
